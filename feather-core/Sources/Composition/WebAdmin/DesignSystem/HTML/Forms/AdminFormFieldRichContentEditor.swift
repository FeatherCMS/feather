public import CSS
import Foundation
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminFormFieldRichContentEditor: Component {
    public struct State: Sendable {
        public let key: String
        public let label: String
        public let value: String?
        public let error: String?
        public let mediaFolderPath: String?

        public init(
            key: String,
            label: String,
            value: String?,
            error: String?,
            mediaFolderPath: String? = nil
        ) {
            self.key = key
            self.label = label
            self.value = value
            self.error = error
            self.mediaFolderPath = mediaFolderPath
        }
    }

    struct BlockDefinition: Sendable {
        let title: String
        let icon: String
        let type: String
    }

    public let state: State
    public init(state: State) {
        self.state = state
    }

    private let blockDefinitions: [BlockDefinition] = [
        .init(title: "Heading", icon: "H", type: "heading"),
        .init(title: "Text", icon: "T", type: "text"),
        .init(title: "Image", icon: "▧", type: "image"),
        .init(title: "Video", icon: "▶", type: "video"),
        .init(title: "Unordered list", icon: "•", type: "ul"),
        .init(title: "Ordered list", icon: "1.", type: "ol"),
        .init(title: "Separator", icon: "—", type: "separator"),
        .init(title: "Grid", icon: "⊞", type: "grid"),
        .init(title: "Blockquote", icon: "“", type: "blockquote"),
        .init(title: "Code block", icon: "{}", type: "code"),
        .init(title: "HTML", icon: "<>", type: "html"),
    ]

    private static let markdownEditorScript = #"""
        if (document.querySelector('#markdownInput')) {
            const initialMarkdown = document.querySelector('#markdownInput').defaultValue || document.querySelector('#markdownInput').value;
            const state = { blocks: [], mode: 'visual', dragging: null, insertPosition: 'bottom', activeContactForm: null };
            const editorExtensions = Array.isArray(window.featherRichContentEditorBlocks)
              ? window.featherRichContentEditorBlocks
              : [];
            function editorExtension(type) { return editorExtensions.find(definition => definition.type === type); }
            const canvas = document.querySelector('#canvas');
            const previewContent = document.querySelector('#previewContent');
            const input = document.querySelector('#markdownInput');
            const status = document.querySelector('#status');
            const marker = document.createElement('div'); marker.className = 'drop-marker';
            function resizeMarkdownInput() {
              if (input.offsetParent === null) return;
              input.style.height = 'auto';
              input.style.height = `${input.scrollHeight}px`;
            }
            input.addEventListener('input', resizeMarkdownInput);
            window.addEventListener('resize', resizeMarkdownInput);

            function newBlock(type, value = '') { return { id: crypto.randomUUID(), type, value, url: '', level: 2 }; }
            function findMatchingBrace(source, openingIndex) {
              let depth = 0; let fenced = false;
              for (let index = openingIndex; index < source.length; index++) {
                const lineStart = source.lastIndexOf('\n', index - 1) + 1;
                if (!source.slice(lineStart, index).trim() && source.startsWith('```', index)) { fenced = !fenced; const lineEnd = source.indexOf('\n', index); if (lineEnd < 0) break; index = lineEnd; continue; }
                if (fenced) continue;
                if (source[index] === '{') depth++;
                else if (source[index] === '}' && --depth === 0) return index;
              }
              return -1;
            }
            function splitMarkdownBlocks(markdown) {
              const lines = markdown.replace(/\r/g, '').split('\n'); const blocks = []; let current = []; let fenced = false; let directiveFence = false; let directiveDepth = 0;
              lines.forEach(line => {
                const trimmed = line.trim();
                if (directiveDepth > 0) {
                  const fenceLine = /^\s*```/.test(line); if (fenceLine) directiveFence = !directiveFence; current.push(line);
                  if (!directiveFence && !fenceLine) directiveDepth += (line.match(/\{/g) || []).length - (line.match(/\}/g) || []).length;
                  if (directiveDepth <= 0) { blocks.push(current.join('\n').trim()); current = []; directiveDepth = 0; directiveFence = false; }
                  return;
                }
                if (fenced) { current.push(line); if (trimmed === '```') { blocks.push(current.join('\n').trim()); current = []; fenced = false; } return; }
                if (/^```/.test(trimmed)) { if (current.length) { blocks.push(current.join('\n').trim()); current = []; } fenced = true; current.push(line); return; }
                if (!trimmed) { if (current.length) { blocks.push(current.join('\n').trim()); current = []; } return; }
                current.push(line);
                if (current.length === 1 && /^@(Grid|ContactForm)\b/.test(trimmed) && line.includes('{')) { directiveDepth = (line.match(/\{/g) || []).length - (line.match(/\}/g) || []).length; if (directiveDepth <= 0) { blocks.push(current.join('\n').trim()); current = []; directiveDepth = 0; } }
              });
              if (current.length) blocks.push(current.join('\n').trim()); return blocks;
            }
            function parseArgumentValue(value) {
              const trimmed = value.trim();
              if ((trimmed.startsWith('"') && trimmed.endsWith('"')) || (trimmed.startsWith("'") && trimmed.endsWith("'"))) {
                try { return JSON.parse(trimmed.startsWith("'") ? '"' + trimmed.slice(1, -1).replace(/"/g, '\\"') + '"' : trimmed); } catch (_) { return trimmed.slice(1, -1); }
              }
              return trimmed;
            }
            function parseDirectiveArguments(value) {
              const result = {};
              const pattern = /(?:^|,)\s*([A-Za-z][\w-]*)\s*:\s*("(?:\\.|[^"])*"|'(?:\\.|[^'])*'|[^,]*)/g;
              for (const match of value.matchAll(pattern)) result[match[1]] = parseArgumentValue(match[2]);
              return result;
            }
            function parseExtensionBlock(part) {
              for (const definition of editorExtensions) {
                const directive = definition.directive.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
                const argument = (definition.argument || 'key').replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
                if (definition.editor === 'marker') {
                  if (new RegExp(`^@${directive}(?:\\(\\s*\\))?$`).test(part)) return newBlock(definition.type);
                  continue;
                }
                const match = part.match(new RegExp(`^@${directive}\\(\\s*${argument}\\s*:\\s*([\\s\\S]+)\\)$`));
                if (match) return newBlock(definition.type, parseArgumentValue(match[1]));
              }
              return null;
            }
            function parseContainerBlock(part) {
              for (const definition of editorExtensions.filter(item => item.isContainer)) {
                const directive = definition.directive.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
                const argument = (definition.argument || 'key').replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
                const match = part.match(new RegExp(`^@${directive}\\(\\s*([\\s\\S]*?)\\)\\s*(?:\\{([\\s\\S]*)\\})?$`));
                if (match) {
                  const args = parseDirectiveArguments(match[1]);
                  if (args[definition.argument || 'key'] === undefined) continue;
                  const hasBody = match[2] !== undefined;
                  const mode = args.displayMode === 'custom' || (args.displayMode === undefined && args.mode === 'custom') ? 'custom' : 'automatic';
                  return Object.assign(newBlock(definition.type, args[definition.argument || 'key']), { children: mode === 'custom' && hasBody ? parseMarkdown(match[2]) : [], mode });
                }
              }
              return null;
            }
            function parseVideoBlock(part) {
              const canonical = part.match(/^@Video\(\s*source\s*:\s*([\s\S]+?)\s*,\s*kind\s*:\s*([\s\S]+?)\s*\)$/);
              if (canonical) return Object.assign(newBlock('video', parseArgumentValue(canonical[1])), { kind: parseArgumentValue(canonical[2]) });
              return null;
            }
            function parseMarkdown(markdown) {
              return splitMarkdownBlocks(markdown).filter(Boolean).map(part => {
                const code = part.match(/^```([^\n]*)\n([\s\S]*?)\n?```$/); if (code) return Object.assign(newBlock('code', code[2]), { language: code[1].trim() });
                if (/^-{3,}$/.test(part)) return newBlock('separator', '');
                if (/^(?:[-*+]\s+|\d+\.\s+)/.test(part)) { const ordered = /^\d+\.\s+/.test(part); return newBlock(ordered ? 'ol' : 'ul', part.split('\n').map(line => line.replace(ordered ? /^\d+\.\s+/ : /^[-*+]\s+/, '')).join('\n')); }
                if (/^>/.test(part)) { const lines = part.split('\n').map(line => line.replace(/^>\s?/, '')); const citeIndex = lines.findIndex(line => /^—\s+/.test(line)); const cite = citeIndex >= 0 ? lines.splice(citeIndex, 1)[0].replace(/^—\s+/, '') : ''; return Object.assign(newBlock('blockquote', lines.filter(Boolean).join('\n')), { cite }); }
                const image = part.match(/^!\[([^\]]*)\]\(([^)]+)\)$/); if (image) return Object.assign(newBlock('image', image[2]), { alt: image[1] });
                const video = part.match(/^<video[^>]*\bsrc=["']([^"']+)["'][^>]*>\s*<\/video>$/i); if (video) return Object.assign(newBlock('video', video[1]), { controls: true, kind: 'file' });
                const videoBlock = parseVideoBlock(part); if (videoBlock) return videoBlock;
                const containerBlock = parseContainerBlock(part); if (containerBlock) return containerBlock;
                const extensionBlock = parseExtensionBlock(part); if (extensionBlock) return extensionBlock;
                const grid = part.match(/^@Grid\(([^)]*)\)\s*\{/); if (grid) { const openingIndex = grid[0].length - 1; const closingIndex = findMatchingBrace(part, openingIndex); if (closingIndex !== part.length - 1) return newBlock('text', part); const settings = { desktop: 3, tablet: 2, mobile: 1 }; grid[1].split(',').forEach(pair => { const match = pair.match(/(desktop|tablet|mobile)\s*:\s*(\d+)/); if (match) settings[match[1]] = Number(match[2]); }); const cellSource = part.slice(openingIndex + 1, closingIndex); const cellPattern = /(?:^|\n)\s*@Cell\s*\{/g; const cells = []; let cell; while ((cell = cellPattern.exec(cellSource))) { const cellOpeningIndex = cellSource.indexOf('{', cell.index); const cellClosingIndex = findMatchingBrace(cellSource, cellOpeningIndex); if (cellClosingIndex < 0) break; cells.push({ blocks: parseMarkdown(cellSource.slice(cellOpeningIndex + 1, cellClosingIndex).trim()) }); cellPattern.lastIndex = cellClosingIndex + 1; } return Object.assign(newBlock('grid', ''), { settings, columnCount: cells.length || 1, columns: cells }); }
                const custom = part.match(/^@([A-Za-z][\w-]*)\(([^]*)\)$/); if (custom) return Object.assign(newBlock('custom', custom[2]), { name: custom[1] });
                const heading = part.match(/^(#{1,6})\s+(.+)$/); if (heading) return Object.assign(newBlock('heading', heading[2]), { level: heading[1].length });
                if (/^<[^>]+[\s\S]*>$/.test(part)) return newBlock('html', part);
                return newBlock('text', part);
              });
            }
            function serializeBlocks(blocks) { return blocks.map(serializeBlock).filter(Boolean).join('\n\n'); }
            function serialize() { return serializeBlocks(state.blocks); }
            function serializeBlock(block) {
              const value = (block.value || '').trim(); const extension = editorExtension(block.type);
              if (extension?.isContainer) return value ? '@' + extension.directive + '(' + (extension.argument || 'key') + ': ' + JSON.stringify(value) + (block.mode === 'custom' ? ', displayMode: custom' : '') + ')' + (block.mode === 'custom' ? ' {\n' + serializeBlocks(block.children || []) + '\n}' : '') : '';
              if (extension?.editor === 'marker') return '@' + extension.directive;
              if (!value && !['code', 'grid', 'separator'].includes(block.type)) return '';
              if (block.type === 'separator') return '---';
              if (block.type === 'heading') return `${'#'.repeat(block.level)} ${value}`;
              if (block.type === 'code') return '```' + (block.language || '').trim() + '\n' + value + '\n```';
              if (block.type === 'ul') return value.split('\n').filter(Boolean).map(item => '- ' + item.trim()).join('\n');
              if (block.type === 'ol') return value.split('\n').filter(Boolean).map((item, index) => `${index + 1}. ${item.trim()}`).join('\n');
              if (block.type === 'blockquote') return value.split('\n').map(line => '> ' + line).join('\n') + (block.cite ? '\n>\n> — ' + block.cite.trim() : '');
              if (block.type === 'image') return `![${(block.alt || '').trim()}](${value})`;
              if (block.type === 'video') return '@Video(source: ' + JSON.stringify(value) + ', kind: "' + (block.kind || 'file') + '")';
              if (extension) return '@' + extension.directive + '(' + (extension.argument || 'key') + ': ' + JSON.stringify(value) + ')';
              if (block.type === 'custom') return '@' + (block.name || '').trim() + '(' + value + ')';
              if (block.type === 'grid') { const settings = block.settings || { desktop: 3, tablet: 2, mobile: 1 }; const columns = (block.columns || []).map(column => '@Cell {\n' + serializeBlocks(column.blocks || []) + '\n}').join('\n'); return '@Grid(desktop: ' + settings.desktop + ', tablet: ' + settings.tablet + ', mobile: ' + settings.mobile + ') {\n' + columns + '\n}'; }
              return value;
            }
            function setStatus(message) { status.textContent = message; clearTimeout(setStatus.timer); setStatus.timer = setTimeout(() => status.textContent = 'Saved locally in editor', 900); }
            function syncRaw() { input.value = serialize(); }
            function updateBlock(id, key, value) { const block = state.blocks.find(item => item.id === id); if (!block) return; block[key] = value; syncRaw(); setStatus('Updated'); }
            const editorRoot = document.querySelector('.mce-app');
            const mediaBaseURL = input.getAttribute('data-media-base-url') || editorRoot?.dataset.markdownMediaBaseUrl || editorRoot?.getAttribute('data-markdown-media-base-url') || '';
            function mediaURL(value) {
              if (!value || !value.startsWith('/') || !mediaBaseURL) return value;
              const pathSegments = value.split('/').filter(Boolean);
              if (!pathSegments.includes('originals') && !pathSegments.includes('variants')) return value;
              try { return new URL(value, mediaBaseURL).toString(); } catch (_) { return mediaBaseURL.replace(/\/$/, '') + value; }
            }
            function pickerFieldKey(type) { const app = document.querySelector('.mce-app'); return app && app.getAttribute(`data-markdown-${type}-picker`); }
            function openMediaPicker(type, apply) { const field = pickerFieldKey(type); const trigger = field && document.querySelector(`[data-media-picker-open="${field}"]`); if (!trigger) { setStatus('Gallery picker unavailable'); return; } state.pendingMedia = { apply }; trigger.click(); }
            ['image', 'video'].forEach(type => { const field = pickerFieldKey(type); const pickerInput = field && document.getElementById(field); if (!pickerInput) return; pickerInput.addEventListener('change', () => { if (!state.pendingMedia || !pickerInput.value) return; state.pendingMedia.apply(pickerInput.value); state.pendingMedia = null; render(); }); });
            function openEmbedPicker(definition, apply) {
              let modal = document.getElementById('mceEmbedPicker');
              if (!modal) {
                modal = document.createElement('dialog'); modal.id = 'mceEmbedPicker'; modal.className = 'mce-embed-picker';
                modal.setAttribute('aria-label', 'Choose from list');
                modal.innerHTML = '<div class="admin-dialog__panel mce-embed-picker-dialog"><div class="admin-dialog__header mce-embed-picker-header"><h2></h2><button type="button" class="button secondary-ghost admin-dialog__close mce-embed-picker-close" aria-label="Close" title="Close" data-embed-picker-close>Close</button></div><div class="mce-embed-picker-search"><input type="search" placeholder="Search…"><button type="button">Search</button></div><div class="mce-embed-picker-list"></div></div>';
                editorRoot.append(modal);
                modal.addEventListener('close', () => document.documentElement.classList.remove('admin-dialog-open'));
                modal.addEventListener('click', event => { if (event.target === modal) { if (modal.close) modal.close(); else modal.removeAttribute('open'); } });
                modal.querySelector('[data-embed-picker-close]').addEventListener('click', () => { if (modal.close) modal.close(); else modal.removeAttribute('open'); });
                modal.querySelector('.mce-embed-picker-search button').addEventListener('click', () => loadEmbedPicker(modal));
                modal.querySelector('.mce-embed-picker-search input').addEventListener('keydown', event => { if (event.key === 'Enter') loadEmbedPicker(modal); });
              }
              modal.dataset.embedType = definition.type; modal.dataset.embedEndpoint = definition.pickerEndpoint || ''; modal.__apply = apply;
              modal.querySelector('.mce-embed-picker-header h2').textContent = `Choose ${definition.title.toLowerCase()}`;
              if (!modal.open) {
                if (modal.showModal) {
                  document.documentElement.classList.add('admin-dialog-open');
                  modal.showModal();
                } else {
                  modal.setAttribute('open', '');
                }
              }
              modal.querySelector('.mce-embed-picker-search input').focus();
              loadEmbedPicker(modal);
            }
            async function loadEmbedPicker(modal) {
              const search = modal.querySelector('.mce-embed-picker-search input').value.trim();
              const endpoint = modal.dataset.embedEndpoint;
              if (!endpoint) return;
              const url = new URL(endpoint, window.location.origin); if (search) url.searchParams.set('search', search);
              const list = modal.querySelector('.mce-embed-picker-list'); list.innerHTML = '<p>Loading…</p>';
              try {
                const response = await fetch(url, { credentials: 'same-origin' }); const html = await response.text();
                const doc = new DOMParser().parseFromString(html, 'text/html'); const items = [...doc.querySelectorAll('[data-mce-picker-item]')];
                list.innerHTML = items.length ? '' : '<p>No matching items.</p>';
                items.forEach(item => { const button = document.createElement('button'); button.type = 'button'; button.textContent = item.getAttribute('data-mce-picker-label') || item.textContent.trim(); button.addEventListener('click', () => { modal.__apply(item.getAttribute('data-mce-picker-item'), button.textContent); if (modal.close) modal.close(); else modal.removeAttribute('open'); render(); }); list.append(button); });
              } catch (_) { list.innerHTML = '<p class="error">Unable to load items.</p>'; }
            }
            async function loadContactFormFields(block) {
              if (!block.value || block.loadingFields) return;
              block.loadingFields = true; block.fieldLoadError = '';
              try {
                const response = await fetch(`/admin/contact/forms/${encodeURIComponent(block.value)}/fields-data/`, { credentials: 'same-origin', headers: { Accept: 'application/json' } });
                if (!response.ok) throw new Error(`HTTP ${response.status}`);
                if (response.redirected) throw new Error('The request was redirected, likely to the sign-in page.');
                if (!(response.headers.get('content-type') || '').toLowerCase().includes('application/json')) throw new Error('The response was not JSON.');
                const form = await response.json();
                if (!Array.isArray(form.items)) throw new Error('The response did not contain a form fields list.');
                block.availableFields = form.items;
              } catch (error) { block.availableFields = []; block.fieldLoadError = `Could not load the selected form fields. ${error.message || 'Check the request and try again.'}`; }
              finally { block.loadingFields = false; if (state.blocks.includes(block)) { syncRaw(); render(); } }
            }
            function renderEmbedControl(body, block, update, definition) {
              const fields = document.createElement('div'); fields.className = 'embed-fields';
              const key = document.createElement('input'); key.value = block.value || ''; key.placeholder = `${definition.title} ${definition.argument || 'key'}`; key.setAttribute('aria-label', key.placeholder); key.addEventListener(definition.isContainer ? 'change' : 'input', event => update('value', event.target.value));
              fields.append(key);
              if (definition.pickerEndpoint) { const picker = document.createElement('button'); picker.type = 'button'; picker.className = 'embed-picker-button'; picker.textContent = block.value ? 'Change selection' : 'Choose from list'; picker.addEventListener('click', () => openEmbedPicker(definition, value => { update('value', value); })); fields.append(picker); }
              body.append(fields);
            }
            function renderExtensionControl(body, block, update, definition) {
              if (definition.type === 'contact-form-field') { const preview = document.createElement('div'); preview.className = 'contact-form-field-preview'; const key = document.createElement('code'); key.textContent = block.value || ''; preview.append(key); body.append(preview); return; }
              if (definition.editor === 'marker') { const names = { 'contact-form-captcha': 'CAPTCHA', 'contact-form-error': 'Error message', 'contact-form-success': 'Success message', 'contact-form-submit': 'Submit button' }; const preview = document.createElement('div'); preview.className = 'contact-form-marker-preview'; const title = document.createElement('strong'); title.textContent = 'Contact Form'; const component = document.createElement('span'); component.textContent = names[block.type] || definition.title; preview.append(title, component); body.append(preview); return; }
              if (definition.editor === 'text') { const field = document.createElement('textarea'); field.value = block.value || ''; field.placeholder = definition.title; field.setAttribute('aria-label', definition.title); configureTextEditor(field); field.addEventListener('input', event => update('value', event.target.value)); body.append(field); return; }
              renderEmbedControl(body, block, update, definition);
            }
            function renderVideoControl(body, block, update) {
              const fields = document.createElement('div'); fields.className = 'media-fields';
              const kind = document.createElement('select'); kind.setAttribute('aria-label', 'Video source type');
              [['file', 'Video file'], ['embed', 'External video']].forEach(([value, label]) => { const option = document.createElement('option'); option.value = value; option.textContent = label; kind.append(option); });
              kind.value = block.kind || 'file'; kind.addEventListener('change', event => { update('kind', event.target.value); render(); });
              const url = document.createElement('input'); url.value = block.value || ''; url.placeholder = kind.value === 'file' ? 'Video URL' : 'Embedded video URL'; url.setAttribute('aria-label', 'Video URL'); url.addEventListener('input', event => update('value', event.target.value));
              fields.append(kind, url);
              if (kind.value === 'file') { const picker = document.createElement('button'); picker.type = 'button'; picker.className = 'media-picker-button'; picker.textContent = 'Choose from gallery'; picker.addEventListener('click', () => openMediaPicker('video', value => update('value', value))); fields.append(picker); }
              body.append(fields);
            }
            function escapeHTML(value) { return value.replace(/[&<>"']/g, character => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[character])); }
            function inlineMarkdown(value) { let html = escapeHTML(value); html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank" rel="noreferrer">$1</a>'); html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>').replace(/__([^_]+)__/g, '<u>$1</u>').replace(/~~([^~]+)~~/g, '<del>$1</del>').replace(/\*([^*]+)\*/g, '<em>$1</em>'); return html; }
            function renderPreviewBlock(block) { let element; if (block.type === 'heading') { element = document.createElement(`h${block.level}`); element.innerHTML = inlineMarkdown(block.value); } else if (block.type === 'text') { element = document.createElement('p'); element.innerHTML = inlineMarkdown(block.value); } else if (block.type === 'separator') element = document.createElement('hr'); else if (block.type === 'ul' || block.type === 'ol') { element = document.createElement(block.type); block.value.split('\n').filter(Boolean).forEach(item => { const li = document.createElement('li'); li.innerHTML = inlineMarkdown(item); element.append(li); }); } else if (block.type === 'blockquote') { element = document.createElement('blockquote'); element.innerHTML = inlineMarkdown(block.value.replace(/\n/g, '<br>')); if (block.cite) { const cite = document.createElement('cite'); cite.textContent = `— ${block.cite}`; element.append(cite); } } else if (block.type === 'image') { element = document.createElement('img'); element.src = mediaURL(block.value); element.alt = block.alt || ''; } else if (block.type === 'video') { if (block.kind === 'embed') { element = document.createElement('iframe'); element.src = block.value; element.title = 'Embedded video'; element.loading = 'lazy'; element.allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'; element.allowFullscreen = true; } else { element = document.createElement('video'); element.src = mediaURL(block.value); element.controls = true; element.preload = 'metadata'; } } else if (block.type === 'code') { element = document.createElement('pre'); const code = document.createElement('code'); code.textContent = block.value; element.append(code); } else if (block.type === 'html') { element = document.createElement('div'); element.innerHTML = block.value; } else if (block.type === 'grid') { const settings = block.settings || { desktop: 3, tablet: 2, mobile: 1 }; element = document.createElement('div'); element.className = 'preview-grid'; element.style.setProperty('--grid-desktop', settings.desktop); element.style.setProperty('--grid-tablet', settings.tablet); element.style.setProperty('--grid-mobile', settings.mobile); (block.columns || []).forEach(column => { const columnElement = document.createElement('div'); columnElement.className = 'preview-grid-column'; (column.blocks || []).forEach(child => columnElement.append(renderPreviewBlock(child))); element.append(columnElement); }); } else { element = document.createElement('pre'); element.className = 'preview-custom'; element.textContent = serializeBlock(block); } return element; }
            function renderContactFormPreview(block) { const container = document.createElement('section'); container.className = 'preview-contact-form'; const title = document.createElement('strong'); title.textContent = `Contact form: ${block.value || 'Choose a form'}`; container.append(title); (block.children || []).forEach(child => container.append(renderPreviewBlock(child))); return container; }
            function renderPreview() { previewContent.innerHTML = ''; if (!state.blocks.length) { previewContent.innerHTML = '<div class="preview-empty">Nothing to preview yet.</div>'; return; } state.blocks.forEach(block => previewContent.append(editorExtension(block.type)?.isContainer ? renderContactFormPreview(block) : renderPreviewBlock(block))); }
            function configureTextEditor(field) {
              field.classList.add('text-editor');
              field.rows = 1;
              const resize = () => { field.style.height = 'auto'; field.style.height = `${field.scrollHeight}px`; };
              if (field.dataset.textEditorAutosize !== 'true') {
                field.dataset.textEditorAutosize = 'true';
                field.addEventListener('input', resize);
              }
              requestAnimationFrame(resize);
            }
            if (editorRoot && editorRoot.dataset.textEditorAutosize !== 'true') {
              editorRoot.dataset.textEditorAutosize = 'true';
              let resizeFrame;
              window.addEventListener('resize', () => {
                cancelAnimationFrame(resizeFrame);
                resizeFrame = requestAnimationFrame(() => {
                  editorRoot.querySelectorAll('.block textarea.text-editor').forEach(field => {
                    field.style.height = 'auto';
                    field.style.height = `${field.scrollHeight}px`;
                  });
                });
              });
              const textEditorObserver = new MutationObserver(() => {
                requestAnimationFrame(() => {
                  editorRoot.querySelectorAll('.block textarea').forEach(configureTextEditor);
                });
              });
              textEditorObserver.observe(editorRoot, { childList: true, subtree: true });
            }
            function makeGridBlock() { return Object.assign(newBlock('grid', ''), { settings: { desktop: 3, tablet: 2, mobile: 1 }, columnCount: 3, columns: [0, 1, 2].map(() => ({ blocks: [] })) }); }
            function ensureGridColumns(block) { block.columns = block.columns || []; block.columnCount = Math.max(1, Math.min(12, block.columnCount || block.columns.length || 1)); while (block.columns.length < block.columnCount) block.columns.push({ blocks: [] }); }
            function updateGridColumn(id, index, value) { const block = state.blocks.find(item => item.id === id); if (!block) return; if (!block.columns) block.columns = []; while (block.columns.length <= index) block.columns.push({ blocks: [] }); block.columns[index].blocks = parseMarkdown(value); syncRaw(); setStatus('Updated'); }
            function createBlockControls(block, collection, onChange) {
              const controls = document.createElement('div'); controls.className = 'drag-controls';
              const handle = document.createElement('span'); handle.className = 'drag-handle'; handle.textContent = '⠿'; handle.title = 'Drag to rearrange'; handle.setAttribute('aria-label', 'Drag to rearrange'); controls.append(handle);
              const createButton = (className, title, text) => { const button = document.createElement('button'); button.type = 'button'; button.className = className; button.title = title; button.setAttribute('aria-label', title); button.textContent = text; return button; };
              const up = createButton('move-button', 'Move up', '↑'); up.disabled = collection.indexOf(block) === 0; up.addEventListener('click', event => { event.stopPropagation(); const index = collection.indexOf(block); if (index <= 0) return; [collection[index - 1], collection[index]] = [collection[index], collection[index - 1]]; onChange('Rearranged'); });
              const down = createButton('move-button', 'Move down', '↓'); down.disabled = collection.indexOf(block) === collection.length - 1; down.addEventListener('click', event => { event.stopPropagation(); const index = collection.indexOf(block); if (index < 0 || index >= collection.length - 1) return; [collection[index + 1], collection[index]] = [collection[index], collection[index + 1]]; onChange('Rearranged'); }); controls.append(up, down);
              const duplicate = createButton('duplicate-button', 'Duplicate component', ''); duplicate.innerHTML = '<svg viewBox="0 0 16 16" aria-hidden="true"><rect x="5" y="2" width="9" height="10" rx="1.5" fill="none" stroke="currentColor" stroke-width="1.4"/><path d="M3 5H2.5A1.5 1.5 0 0 0 1 6.5v7A1.5 1.5 0 0 0 2.5 15h6A1.5 1.5 0 0 0 10 13.5V13" fill="none" stroke="currentColor" stroke-width="1.4"/></svg>'; duplicate.addEventListener('click', event => { event.stopPropagation(); const index = collection.indexOf(block); if (index < 0) return; collection.splice(index + 1, 0, cloneBlock(block)); onChange('Duplicated'); }); controls.append(duplicate);
              const remove = createButton('remove', 'Remove component', '×');
              remove.addEventListener('click', event => {
                event.stopPropagation();
                if (remove.dataset.confirming === 'true') { const index = collection.indexOf(block); if (index < 0) return; collection.splice(index, 1); onChange('Removed'); return; }
                editorRoot.querySelectorAll('.remove.is-confirming').forEach(button => { button.classList.remove('is-confirming'); delete button.dataset.confirming; button.textContent = '×'; button.title = 'Remove component'; button.setAttribute('aria-label', 'Remove component'); });
                remove.dataset.confirming = 'true'; remove.classList.add('is-confirming'); remove.textContent = 'Confirm'; remove.title = 'Click again to delete this block'; remove.setAttribute('aria-label', 'Confirm delete block'); clearTimeout(setStatus.timer);
              });
              return { controls, remove };
            }
            function renderNestedGridEditor(body, grid) {
              const contactForm = state.activeContactForm;
              grid.settings = Object.assign({ desktop: 3, tablet: 2, mobile: 1 }, grid.settings || {}); ensureGridColumns(grid);
              const controls = document.createElement('div'); controls.className = 'contact-form-grid-editor';
              const settings = document.createElement('div'); settings.className = 'grid-settings';
              const responsive = document.createElement('div'); responsive.className = 'grid-responsive';
              [['desktop', grid.settings.desktop], ['tablet', grid.settings.tablet], ['mobile', grid.settings.mobile], ['cells', grid.columnCount]].forEach(([size, value]) => {
                const label = document.createElement('label'); label.className = 'grid-setting'; label.textContent = size === 'cells' ? 'Cells' : size.charAt(0).toUpperCase() + size.slice(1);
                const field = document.createElement('input'); field.className = 'grid-setting-input'; field.type = 'number'; field.min = 1; field.max = 12; field.value = value; field.setAttribute('aria-label', label.textContent);
                field.addEventListener('change', event => { const nextValue = Math.max(1, Math.min(12, Number(event.target.value) || 1)); if (size === 'cells') grid.columnCount = nextValue; else grid.settings[size] = nextValue; ensureGridColumns(grid); contactForm.mode = 'custom'; syncRaw(); render(); });
                label.append(field); responsive.append(label);
              });
              settings.append(responsive);
              const columns = document.createElement('div'); columns.className = 'grid-columns contact-form-grid-columns'; columns.style.setProperty('--grid-desktop', grid.settings.desktop); columns.style.setProperty('--grid-tablet', grid.settings.tablet); columns.style.setProperty('--grid-mobile', grid.settings.mobile);
              for (let columnIndex = 0; columnIndex < grid.columnCount; columnIndex++) {
                const column = document.createElement('div'); column.className = 'grid-column contact-form-grid-column'; const title = document.createElement('label'); title.textContent = `Cell ${columnIndex + 1}`; column.append(title); const children = grid.columns[columnIndex].blocks || [];
                children.forEach((child, childIndex) => {
                  const card = document.createElement('article'); card.className = 'block grid-child contact-form-grid-child'; card.draggable = true;
                  const childControls = createBlockControls(child, children, message => { contactForm.mode = 'custom'; syncRaw(); render(); setStatus(message); }); card.append(childControls.controls);
                  const childBody = document.createElement('div'); childBody.className = 'block-body'; const label = document.createElement('label'); label.className = 'block-label'; label.textContent = child.displayTitle || editorExtension(child.type)?.title || child.type; childBody.append(label); renderBlockContent(childBody, child, (key, value) => { child[key] = value; syncRaw(); setStatus('Updated'); }); card.append(childBody);
                  card.append(childControls.remove);
                  card.addEventListener('dragstart', event => { event.stopPropagation(); event.dataTransfer.effectAllowed = 'move'; state.dragging = { kind: 'contact-form-grid-child', formId: contactForm?.id, grid, columnIndex, childIndex }; card.classList.add('dragging'); }); card.addEventListener('dragend', event => { event.stopPropagation(); clearDragState(); });
                  column.append(card);
                });
                column.addEventListener('dragover', event => { if (state.dragging?.formId === contactForm?.id && ['contact-form-field', 'contact-form-component', 'contact-form-grid-child', 'contact-form-child'].includes(state.dragging.kind)) { event.preventDefault(); column.classList.add('drop-target'); } }); column.addEventListener('dragleave', () => column.classList.remove('drop-target'));
                column.addEventListener('drop', event => { event.preventDefault(); event.stopPropagation(); const drag = state.dragging; if (!drag || drag.formId !== contactForm?.id || !['contact-form-field', 'contact-form-component', 'contact-form-grid-child', 'contact-form-child'].includes(drag.kind)) return; let moved; if (drag.kind === 'contact-form-field') { if (!flattenContactFormBlocks(contactForm.children).some(child => child.type === 'contact-form-field' && child.value === drag.key)) moved = Object.assign(newBlock('contact-form-field', drag.key), { displayTitle: drag.label }); } else if (drag.kind === 'contact-form-component') moved = createBlock(drag.type); else if (drag.kind === 'contact-form-grid-child') moved = drag.grid.columns[drag.columnIndex].blocks.splice(drag.childIndex, 1)[0]; else if (drag.kind === 'contact-form-child') moved = contactForm.children.splice(drag.childIndex, 1)[0]; if (moved) { children.push(moved); contactForm.mode = 'custom'; } state.dragging = null; syncRaw(); render(); });
                columns.append(column);
              }
              settings.append(columns); controls.append(settings); body.append(controls);
            }
            function renderBlockContent(body, block, update) {
              const extension = editorExtension(block.type);
              if (block.type === 'grid') { if (state.activeContactForm) renderNestedGridEditor(body, block); else { const field = document.createElement('textarea'); field.className = 'contact-form-grid-source'; field.value = serializeBlock(block); field.setAttribute('aria-label', 'Grid layout Markdown'); field.addEventListener('input', () => { const parsed = parseMarkdown(field.value).find(item => item.type === 'grid'); if (parsed) { Object.assign(block, parsed); syncRaw(); setStatus('Updated'); } }); body.append(field); } return; }
              if (extension) { renderExtensionControl(body, block, update, extension); const label = body.querySelector('.block-label'); if (label) { label.hidden = extension.editor === 'marker'; label.textContent = extension.editor === 'marker' ? '' : extension.type === 'contact-form-field' ? 'Contact form field' : extension.title; } return; }
              if (block.type === 'heading') { const toolbar = document.createElement('div'); toolbar.className = 'heading-toolbar'; toolbar.setAttribute('aria-label', 'Heading level'); toolbar.innerHTML = [1,2,3,4,5,6].map(level => `<button type="button" class="${level === block.level ? 'active' : ''}" data-level="${level}" title="Heading ${level}">H${level}</button>`).join(''); toolbar.querySelectorAll('[data-level]').forEach(button => button.addEventListener('click', () => { update('level', Number(button.dataset.level)); render(); })); const field = document.createElement('input'); field.value = block.value; field.placeholder = 'Heading text…'; field.setAttribute('aria-label', 'Heading text'); field.addEventListener('input', e => update('value', e.target.value)); body.append(toolbar, field); }
              else if (block.type === 'separator') { const rule = document.createElement('div'); rule.className = 'preview-content'; rule.innerHTML = '<hr>'; body.append(rule); }
              else if (block.type === 'ul' || block.type === 'ol') { const toolbar = document.createElement('div'); toolbar.className = 'format-toolbar'; toolbar.setAttribute('aria-label', 'Text formatting'); toolbar.innerHTML = '<button type="button" data-format="bold" title="Bold"><strong>B</strong></button><button type="button" data-format="italic" title="Italic"><em>I</em></button><button type="button" data-format="underline" title="Underline"><u>U</u></button><button type="button" data-format="strike" title="Strikethrough"><del>S</del></button><button type="button" data-format="link" title="Add link">↗</button>'; const field = document.createElement('textarea'); field.className = 'list-editor'; field.value = block.value; field.placeholder = 'One list item per line…'; field.setAttribute('aria-label', `${block.type === 'ul' ? 'Unordered' : 'Ordered'} list items`); field.addEventListener('input', e => update('value', e.target.value)); body.append(toolbar, field); toolbar.querySelectorAll('[data-format]').forEach(button => button.addEventListener('click', () => formatSelectionForBlock(field, block, update, button.dataset.format))); }
              else if (block.type === 'blockquote') { const fields = document.createElement('div'); fields.className = 'quote-fields'; const quote = document.createElement('textarea'); quote.value = block.value; quote.placeholder = 'Quote text…'; quote.setAttribute('aria-label', 'Blockquote text'); quote.addEventListener('input', e => update('value', e.target.value)); const cite = document.createElement('input'); cite.value = block.cite || ''; cite.placeholder = 'Citation (optional)'; cite.setAttribute('aria-label', 'Blockquote citation'); cite.addEventListener('input', e => update('cite', e.target.value)); fields.append(quote, cite); body.append(fields); }
              else if (block.type === 'html') { const field = document.createElement('textarea'); field.className = 'html-editor'; field.value = block.value; field.placeholder = '<div>Raw HTML…</div>'; field.setAttribute('aria-label', 'Raw HTML'); field.addEventListener('input', e => update('value', e.target.value)); body.append(field); }
              else if (block.type === 'code') { const language = document.createElement('input'); language.className = 'code-language'; language.value = block.language; language.placeholder = 'Language (e.g. swift)'; language.setAttribute('aria-label', 'Code language'); language.addEventListener('input', e => update('language', e.target.value)); const field = document.createElement('textarea'); field.className = 'code-editor'; field.value = block.value; field.placeholder = 'Paste or type code…'; field.setAttribute('aria-label', 'Code'); field.addEventListener('input', e => update('value', e.target.value)); body.append(language, field); }
              else if (block.type === 'image') { const fields = document.createElement('div'); fields.className = 'media-fields'; const url = document.createElement('input'); url.value = block.value; url.placeholder = 'Image URL'; url.setAttribute('aria-label', 'Image URL'); url.addEventListener('input', e => update('value', e.target.value)); const picker = document.createElement('button'); picker.type = 'button'; picker.className = 'media-picker-button'; picker.textContent = 'Choose from gallery'; picker.addEventListener('click', () => openMediaPicker('image', value => update('value', value))); fields.append(url, picker); const alt = document.createElement('input'); alt.value = block.alt || ''; alt.placeholder = 'Alt text'; alt.setAttribute('aria-label', 'Image alt text'); alt.addEventListener('input', e => update('alt', e.target.value)); fields.append(alt); body.append(fields); }
              else if (block.type === 'video') { renderVideoControl(body, block, update); }
              else if (block.type === 'custom') { const fields = document.createElement('div'); fields.className = 'custom-fields'; const name = document.createElement('input'); name.value = block.name || 'CustomBlock'; name.placeholder = 'Component name'; name.setAttribute('aria-label', 'Custom component name'); name.addEventListener('input', e => update('name', e.target.value)); const args = document.createElement('input'); args.value = block.value; args.placeholder = 'Arguments, e.g. id: 123'; args.setAttribute('aria-label', 'Custom component arguments'); args.addEventListener('input', e => update('value', e.target.value)); fields.append(name, args); body.append(fields); }
              else { const toolbar = document.createElement('div'); toolbar.className = 'format-toolbar'; toolbar.setAttribute('aria-label', 'Text formatting'); toolbar.innerHTML = '<button type="button" data-format="bold" title="Bold"><strong>B</strong></button><button type="button" data-format="italic" title="Italic"><em>I</em></button><button type="button" data-format="underline" title="Underline"><u>U</u></button><button type="button" data-format="strike" title="Strikethrough"><del>S</del></button><button type="button" data-format="link" title="Add link">↗</button>'; const field = document.createElement('textarea'); field.value = block.value; field.placeholder = 'Write text…'; field.setAttribute('aria-label', 'Text with Markdown formatting'); configureTextEditor(field); field.addEventListener('input', e => update('value', e.target.value)); body.append(toolbar, field); toolbar.querySelectorAll('[data-format]').forEach(button => button.addEventListener('click', () => formatSelectionForBlock(field, block, update, button.dataset.format))); }
            }
            function renderContactFormContainer(body, block, definition, update) {
              block.children = block.children || [];
              renderEmbedControl(body, block, (key, value) => { if (key === 'value' && value !== block.value) { block.availableFields = null; block.fieldLoadError = ''; block.children = []; update(key, value); if (block.mode === 'custom') loadContactFormFields(block); } else update(key, value); }, definition);
              const modeSwitch = document.createElement('div'); modeSwitch.className = 'mode-switch contact-form-mode-switch'; modeSwitch.setAttribute('role', 'tablist'); modeSwitch.setAttribute('aria-label', 'Contact form display mode');
              [['automatic', 'Standard'], ['custom', 'Rich content editor']].forEach(([mode, title]) => { const button = document.createElement('button'); button.type = 'button'; button.className = block.mode === mode ? 'active' : ''; button.textContent = title; button.setAttribute('role', 'tab'); button.setAttribute('aria-selected', String(block.mode === mode)); button.addEventListener('click', () => { if (block.mode === mode) return; block.mode = mode; syncRaw(); render(); if (mode === 'custom' && block.value) loadContactFormFields(block); }); modeSwitch.append(button); });
              body.append(modeSwitch);
              if (block.mode !== 'custom') return;
              const panel = document.createElement('div'); panel.className = 'contact-form-layout-editor';
              const toolbar = document.createElement('div'); toolbar.className = 'component-list contact-form-component-toolbar'; const fieldsLabel = document.createElement('p'); fieldsLabel.className = 'eyebrow contact-form-toolbar-heading'; fieldsLabel.textContent = 'Fields'; toolbar.append(fieldsLabel);
              if (block.loadingFields) { const loading = document.createElement('p'); loading.className = 'contact-form-palette-status'; loading.textContent = 'Loading fields…'; toolbar.append(loading); }
              else if (block.fieldLoadError) { const error = document.createElement('p'); error.className = 'error contact-form-palette-status'; error.textContent = block.fieldLoadError; const retry = document.createElement('button'); retry.type = 'button'; retry.className = 'button secondary'; retry.textContent = 'Retry'; retry.addEventListener('click', () => { block.availableFields = null; loadContactFormFields(block); }); toolbar.append(error, retry); }
              else if (block.availableFields?.length) {
                const used = flattenContactFormBlocks(block.children).filter(child => child.type === 'contact-form-field').map(child => child.value);
                block.availableFields.forEach(field => { const button = document.createElement('button'); button.type = 'button'; button.className = 'component-button contact-form-field-option'; button.title = field.key; button.draggable = !used.includes(field.key); button.disabled = used.includes(field.key); const icon = document.createElement('span'); icon.className = 'component-icon'; icon.textContent = '▤'; icon.setAttribute('aria-hidden', 'true'); const label = document.createElement('span'); label.textContent = field.label || field.key; const description = document.createElement('small'); description.textContent = field.key; button.append(icon, label, description); button.addEventListener('click', () => { if (flattenContactFormBlocks(block.children).some(child => child.type === 'contact-form-field' && child.value === field.key)) return; const child = Object.assign(newBlock('contact-form-field', field.key), { displayTitle: field.label || field.key }); insertContactFormChild(block, child); }); button.addEventListener('dragstart', event => { event.stopPropagation(); event.dataTransfer.effectAllowed = 'copy'; event.dataTransfer.setData('text/plain', field.key); state.dragging = { kind: 'contact-form-field', formId: block.id, key: field.key, label: field.label || field.key }; }); button.addEventListener('dragend', event => { event.stopPropagation(); clearDragState(); }); toolbar.append(button); });
              } else if (block.value && !block.loadingFields && !block.fieldLoadError) { const empty = document.createElement('p'); empty.className = 'contact-form-palette-status'; empty.textContent = 'No fields are assigned to this form.'; toolbar.append(empty); }
              const separator = document.createElement('hr'); separator.className = 'contact-form-toolbar-separator'; toolbar.append(separator); const componentsLabel = document.createElement('p'); componentsLabel.className = 'eyebrow contact-form-toolbar-heading'; componentsLabel.textContent = 'Form components'; toolbar.append(componentsLabel);
              const componentTitles = { 'contact-form-captcha': 'CAPTCHA', 'contact-form-submit': 'Submit button', 'contact-form-error': 'Error message', 'contact-form-success': 'Success message' }; const componentOrder = ['contact-form-captcha', 'contact-form-submit', 'contact-form-error', 'contact-form-success'];
              editorExtensions.filter(item => item.isContainerChild && item.type !== 'contact-form-field').sort((left, right) => componentOrder.indexOf(left.type) - componentOrder.indexOf(right.type)).forEach(item => { if (flattenContactFormBlocks(block.children).some(child => child.type === item.type)) return; const titleText = componentTitles[item.type] || item.title; const button = document.createElement('button'); button.type = 'button'; button.className = 'component-button contact-form-marker-option'; button.draggable = true; const icon = document.createElement('span'); icon.className = 'component-icon'; icon.textContent = item.icon; icon.setAttribute('aria-hidden', 'true'); const label = document.createElement('span'); label.textContent = titleText; const description = document.createElement('small'); description.textContent = titleText; button.append(icon, label, description); button.addEventListener('click', () => { if (flattenContactFormBlocks(block.children).some(child => child.type === item.type)) return; insertContactFormChild(block, createBlock(item.type)); }); button.addEventListener('dragstart', event => { event.stopPropagation(); event.dataTransfer.effectAllowed = 'copy'; event.dataTransfer.setData('text/plain', item.type); state.dragging = { kind: 'contact-form-component', formId: block.id, type: item.type }; }); button.addEventListener('dragend', event => { event.stopPropagation(); clearDragState(); }); toolbar.append(button); });
              panel.append(toolbar);
              const validation = validateContactFormLayout(block);
              if (validation.length && !block.fieldLoadError) { const message = document.createElement('p'); message.className = 'contact-form-layout-validation'; message.textContent = validation.join(' '); panel.append(message); }
              const layout = document.createElement('div'); layout.className = 'contact-form-layout-children'; const previousContactForm = state.activeContactForm; state.activeContactForm = block;
              block.children.forEach((child, index) => {
                const card = document.createElement('article'); card.className = 'block contact-form-layout-child'; card.draggable = true;
                const childControls = createBlockControls(child, block.children, message => { block.mode = 'custom'; syncRaw(); render(); setStatus(message); });
                card.append(childControls.controls);
                const childBody = document.createElement('div'); childBody.className = 'contact-form-layout-child-body block-body'; childBody.innerHTML = '<label class="block-label"></label>'; renderBlockContent(childBody, child, (key, value) => { child[key] = value; syncRaw(); setStatus('Updated'); }); if (child.displayTitle && child.type !== 'contact-form-field' && editorExtension(child.type)?.editor !== 'marker') childBody.querySelector('.block-label').textContent = child.displayTitle; card.append(childBody);
                card.append(childControls.remove);
                card.addEventListener('dragstart', event => { event.stopPropagation(); event.dataTransfer.effectAllowed = 'move'; state.dragging = { kind: 'contact-form-child', formId: block.id, childIndex: index }; card.classList.add('dragging'); });
                card.addEventListener('dragend', event => { event.stopPropagation(); clearDragState(); });
                card.addEventListener('dragover', event => { event.preventDefault(); event.stopPropagation(); marker.classList.remove('visible'); marker.dataset.position = ''; card.classList.add('drop-target'); });
                card.addEventListener('dragleave', () => card.classList.remove('drop-target'));
                card.addEventListener('drop', event => { event.preventDefault(); event.stopPropagation(); card.classList.remove('drop-target'); const dragState = state.dragging; if (!dragState || dragState.formId && dragState.formId !== block.id || dragState.kind === 'existing' && dragState.id === block.id) return; const after = event.clientY > card.getBoundingClientRect().top + card.offsetHeight / 2; let moved; let source = null; let sourceIndex = -1; if (dragState.kind === 'new') moved = createBlock(dragState.type); else if (dragState.kind === 'contact-form-field') { if (!flattenContactFormBlocks(block.children).some(item => item.type === 'contact-form-field' && item.value === dragState.key)) moved = Object.assign(newBlock('contact-form-field', dragState.key), { displayTitle: dragState.label }); } else if (dragState.kind === 'contact-form-component') moved = createBlock(dragState.type); else if (dragState.kind === 'contact-form-child') { source = block.children; sourceIndex = dragState.childIndex; moved = source.splice(sourceIndex, 1)[0]; } else if (dragState.kind === 'contact-form-grid-child') { source = dragState.grid.columns[dragState.columnIndex].blocks; sourceIndex = dragState.childIndex; moved = source.splice(sourceIndex, 1)[0]; } else if (dragState.kind === 'existing' || dragState.kind === 'grid-child') { const taken = takeDraggedBlock(dragState); if (taken) { moved = taken.block; source = dragState.kind === 'existing' ? state.blocks : null; sourceIndex = taken.index; } } if (!moved) return; let target = index + (after ? 1 : 0); if (source === block.children && sourceIndex < target) target--; block.children.splice(target, 0, moved); block.mode = 'custom'; state.dragging = null; syncRaw(); render(); setStatus('Moved into contact form'); });
                layout.append(card);
              });
              state.activeContactForm = previousContactForm;
              if (!block.children.length) { const empty = document.createElement('div'); empty.className = 'contact-form-layout-empty'; empty.textContent = 'Drop components here to add them to the form'; layout.append(empty); }
              layout.addEventListener('dragover', event => { if (state.dragging && (!state.dragging.formId || state.dragging.formId === block.id)) { event.preventDefault(); layout.classList.add('drop-target'); } });
              layout.addEventListener('dragleave', event => { if (!layout.contains(event.relatedTarget)) layout.classList.remove('drop-target'); });
              layout.addEventListener('drop', event => { if (!state.dragging || event.target.closest('.contact-form-layout-child') || state.dragging.formId && state.dragging.formId !== block.id) return; event.preventDefault(); event.stopPropagation(); layout.classList.remove('drop-target'); const dragState = state.dragging; let moved; if (dragState.kind === 'new') moved = createBlock(dragState.type); else if (dragState.kind === 'contact-form-field') { if (!flattenContactFormBlocks(block.children).some(item => item.type === 'contact-form-field' && item.value === dragState.key)) moved = Object.assign(newBlock('contact-form-field', dragState.key), { displayTitle: dragState.label }); } else if (dragState.kind === 'contact-form-component') moved = createBlock(dragState.type); else if (dragState.kind === 'contact-form-child') moved = block.children.splice(dragState.childIndex, 1)[0]; else if (dragState.kind === 'contact-form-grid-child') moved = dragState.grid.columns[dragState.columnIndex].blocks.splice(dragState.childIndex, 1)[0]; else if (dragState.kind === 'existing' || dragState.kind === 'grid-child') moved = takeDraggedBlock(dragState)?.block; if (!moved) return; block.children.push(moved); block.mode = 'custom'; state.dragging = null; syncRaw(); render(); setStatus('Moved into contact form'); });
              panel.append(layout);
              body.append(panel);
              if (block.value && !block.availableFields && !block.loadingFields && !block.fieldLoadError) loadContactFormFields(block);
            }
            function validateContactFormLayout(block) {
              if (block.mode !== 'custom') return [];
              if (!block.value) return ['Choose a contact form.'];
              if (block.loadingFields) return ['Wait for this form’s fields to load.'];
              if (block.fieldLoadError) return [block.fieldLoadError];
              if (!Array.isArray(block.availableFields)) return ['Could not load the selected form’s fields.'];
              const errors = []; const children = flattenContactFormBlocks(block.children); const fields = children.filter(child => child.type === 'contact-form-field'); const keys = fields.map(field => (field.value || '').trim());
              const expected = block.availableFields.map(field => field.key); const duplicates = [...new Set(keys.filter((key, index) => key && keys.indexOf(key) !== index))]; const missing = expected.filter(key => !keys.includes(key)); const unknown = keys.filter(key => key && !expected.includes(key));
              if (missing.length) errors.push(`Add every assigned field (${missing.length} missing).`);
              if (duplicates.length) errors.push('Each field can appear only once.');
              if (unknown.length) errors.push('Remove fields not assigned to this form.');
              if (fields.some(field => !field.value.trim())) errors.push('Choose a key for each field block.');
              for (const [type, title] of [['contact-form-submit', 'Submit'], ['contact-form-error', 'Error message'], ['contact-form-success', 'Success message']]) { const count = children.filter(child => child.type === type).length; if (count !== 1) errors.push(`Add exactly one ${title} block.`); }
              if (children.filter(child => child.type === 'contact-form-captcha').length !== 1) errors.push('Add exactly one CAPTCHA block.');
              return errors;
            }
            function flattenContactFormBlocks(blocks) { return (blocks || []).flatMap(block => [block, ...(block.columns || []).flatMap(column => flattenContactFormBlocks(column.blocks)), ...flattenContactFormBlocks(block.children)]); }
            function formatSelectionForBlock(field, block, update, format) { const start = field.selectionStart; const end = field.selectionEnd; if (start === end) return; const selected = field.value.slice(start, end); const wrappers = { bold: ['**', '**'], italic: ['*', '*'], underline: ['__', '__'], strike: ['~~', '~~'] }; let before; let after; if (format === 'link') { const url = window.prompt('Link URL', 'https://'); if (!url) return; before = '['; after = `](${url})`; } else { [before, after] = wrappers[format]; } const value = field.value.slice(0, start) + before + selected + after + field.value.slice(end); update('value', value); field.value = value; field.focus(); field.setSelectionRange(start + before.length, end + before.length); setStatus('Formatted'); }
            function render() {
              canvas.innerHTML = '';
              if (!state.blocks.length) { canvas.innerHTML = '<div class="empty"><strong>Your canvas is empty.</strong><br>Drag here a component from above to get started.</div>'; return; }
              state.blocks.forEach((block, index) => {
                const item = document.createElement('article'); item.className = 'block'; item.draggable = true; item.dataset.id = block.id;
                item.innerHTML = `<div class="block-body"><label class="block-label">${block.type === 'heading' ? `Heading ${block.level}` : block.type}</label></div>`;
                const blockControls = createBlockControls(block, state.blocks, message => { syncRaw(); render(); setStatus(message); });
                item.prepend(blockControls.controls);
                item.append(blockControls.remove);
                const body = item.querySelector('.block-body');
                const extension = editorExtension(block.type);
                if (extension?.isContainer) { renderContactFormContainer(body, block, extension, (key, value) => updateBlock(block.id, key, value)); body.querySelector('.block-label').textContent = extension.title; }
                else if (extension) { renderExtensionControl(body, block, (key, value) => updateBlock(block.id, key, value), extension); body.querySelector('.block-label').textContent = extension.title; }
                else if (block.type === 'separator') { const rule = document.createElement('div'); rule.className = 'preview-content'; rule.innerHTML = '<hr>'; body.querySelector('.block-label').textContent = 'Separator'; body.append(rule); }
                else if (block.type === 'ul' || block.type === 'ol') { const toolbar = document.createElement('div'); toolbar.className = 'format-toolbar'; toolbar.setAttribute('aria-label', 'Text formatting'); toolbar.innerHTML = '<button type="button" data-format="bold" title="Bold"><strong>B</strong></button><button type="button" data-format="italic" title="Italic"><em>I</em></button><button type="button" data-format="underline" title="Underline"><u>U</u></button><button type="button" data-format="strike" title="Strikethrough"><del>S</del></button><button type="button" data-format="link" title="Add link">↗</button>'; const field = document.createElement('textarea'); field.className = 'list-editor'; field.value = block.value; field.placeholder = 'One list item per line…'; field.setAttribute('aria-label', `${block.type === 'ul' ? 'Unordered' : 'Ordered'} list items`); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.querySelector('.block-label').textContent = block.type === 'ul' ? 'Unordered list' : 'Ordered list'; body.append(toolbar, field); toolbar.querySelectorAll('[data-format]').forEach(button => button.addEventListener('click', () => formatSelection(field, block.id, button.dataset.format))); }
                else if (block.type === 'blockquote') { const fields = document.createElement('div'); fields.className = 'quote-fields'; const quote = document.createElement('textarea'); quote.value = block.value; quote.placeholder = 'Quote text…'; quote.setAttribute('aria-label', 'Blockquote text'); quote.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); const cite = document.createElement('input'); cite.value = block.cite || ''; cite.placeholder = 'Citation (optional)'; cite.setAttribute('aria-label', 'Blockquote citation'); cite.addEventListener('input', e => updateBlock(block.id, 'cite', e.target.value)); fields.append(quote, cite); body.querySelector('.block-label').textContent = 'Blockquote'; body.append(fields); }
                else if (block.type === 'heading') { const toolbar = document.createElement('div'); toolbar.className = 'heading-toolbar'; toolbar.setAttribute('aria-label', 'Heading level'); toolbar.innerHTML = [1,2,3,4,5,6].map(level => `<button type="button" class="${level === block.level ? 'active' : ''}" data-level="${level}" title="Heading ${level}">H${level}</button>`).join(''); toolbar.querySelectorAll('[data-level]').forEach(button => button.addEventListener('click', () => { updateBlock(block.id, 'level', Number(button.dataset.level)); render(); })); const field = document.createElement('input'); field.value = block.value; field.placeholder = 'Heading text…'; field.setAttribute('aria-label', 'Heading text'); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.querySelector('.block-label').after(toolbar, field); }
                else if (block.type === 'html') { const field = document.createElement('textarea'); field.className = 'html-editor'; field.value = block.value; field.placeholder = '<div>Raw HTML…</div>'; field.setAttribute('aria-label', 'Raw HTML'); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.querySelector('.block-label').textContent = 'Raw HTML'; body.append(field); }
                else if (block.type === 'code') { const language = document.createElement('input'); language.className = 'code-language'; language.value = block.language; language.placeholder = 'Language (e.g. swift)'; language.setAttribute('aria-label', 'Code language'); language.addEventListener('input', e => updateBlock(block.id, 'language', e.target.value)); const field = document.createElement('textarea'); field.className = 'code-editor'; field.value = block.value; field.placeholder = 'Paste or type code…'; field.setAttribute('aria-label', 'Code'); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.querySelector('.block-label').textContent = 'Code block'; body.append(language, field); }
                else if (block.type === 'grid') {
                  const settings = block.settings || { desktop: 3, tablet: 2, mobile: 1 };
                  block.settings = settings;
                  block.columns = block.columns || [];
                  ensureGridColumns(block);
                  const controls = document.createElement('div'); controls.className = 'grid-settings';
                  const responsive = document.createElement('div'); responsive.className = 'grid-responsive';
                  [['desktop', settings.desktop], ['tablet', settings.tablet], ['mobile', settings.mobile], ['cells', block.columnCount]].forEach(([size, value]) => {
                    const label = document.createElement('label'); label.className = 'grid-setting'; label.textContent = size === 'cells' ? 'Cells' : size.charAt(0).toUpperCase() + size.slice(1);
                    const field = document.createElement('input'); field.className = 'grid-setting-input'; field.type = 'number'; field.min = 1; field.max = 12; field.value = value; field.setAttribute('aria-label', label.textContent);
                    field.addEventListener('change', event => { const nextValue = Math.max(1, Math.min(12, Number(event.target.value) || 1)); if (size === 'cells') block.columnCount = nextValue; else block.settings[size] = nextValue; ensureGridColumns(block); syncRaw(); render(); });
                    label.append(field); responsive.append(label);
                  });
                  const columns = document.createElement('div'); columns.className = 'grid-columns'; columns.style.setProperty('--grid-desktop', settings.desktop); columns.style.setProperty('--grid-tablet', settings.tablet); columns.style.setProperty('--grid-mobile', settings.mobile);
                  for (let columnIndex = 0; columnIndex < block.columnCount; columnIndex++) {
                    const column = document.createElement('div'); column.className = 'grid-column';
                    const label = document.createElement('label'); label.textContent = `Cell ${columnIndex + 1}`; column.append(label);
                    const children = block.columns[columnIndex].blocks || [];
                    children.forEach(child => {
                      const childCard = document.createElement('article'); childCard.className = 'grid-child block'; childCard.draggable = true;
                      const childControls = createBlockControls(child, children, message => { syncRaw(); render(); setStatus(message); }); childCard.append(childControls.controls);
                      const childBody = document.createElement('div'); childBody.className = 'block-body'; const childLabel = document.createElement('label'); childLabel.className = 'block-label'; childLabel.textContent = child.type === 'heading' ? `Heading ${child.level}` : child.type; childBody.append(childLabel);
                      renderBlockContent(childBody, child, (key, value) => { child[key] = value; syncRaw(); setStatus('Updated'); }); childCard.append(childBody, childControls.remove);
                      childCard.addEventListener('dragstart', event => { event.stopPropagation(); event.dataTransfer.effectAllowed = 'move'; state.dragging = { kind: 'grid-child', gridId: block.id, columnIndex, childIndex: children.indexOf(child) }; childCard.classList.add('dragging'); });
                      childCard.addEventListener('dragend', event => { event.stopPropagation(); clearDragState(); });
                      childCard.addEventListener('dragover', event => { if (!state.dragging || !['existing', 'grid-child'].includes(state.dragging.kind)) return; event.preventDefault(); event.stopPropagation(); marker.classList.remove('visible'); marker.dataset.position = ''; canvas.classList.remove('drag-over'); childCard.classList.add('drop-target'); });
                      childCard.addEventListener('drop', event => { if (!state.dragging || !['existing', 'grid-child'].includes(state.dragging.kind)) return; event.preventDefault(); event.stopPropagation(); const drag = state.dragging; const targetIndex = children.indexOf(child); const sameColumn = drag.kind === 'grid-child' && drag.gridId === block.id && drag.columnIndex === columnIndex; const from = sameColumn ? drag.childIndex : -1; const moved = takeDraggedBlock(drag); if (!moved) return; const to = Math.min(Math.max(0, targetIndex - (sameColumn && from < targetIndex ? 1 : 0)), block.columns[columnIndex].blocks.length); block.columns[columnIndex].blocks.splice(to, 0, moved.block); clearDragState(); syncRaw(); render(); setStatus('Moved into grid'); });
                      column.append(childCard);
                    });
                    column.addEventListener('dragover', event => { event.preventDefault(); event.stopPropagation(); marker.classList.remove('visible'); marker.dataset.position = ''; canvas.classList.remove('drag-over'); if (state.dragging && ['new', 'existing', 'grid-child'].includes(state.dragging.kind)) column.classList.add('drop-target'); });
                    column.addEventListener('dragleave', () => column.classList.remove('drop-target'));
                    column.addEventListener('drop', event => { event.preventDefault(); event.stopPropagation(); if (!state.dragging || !['new', 'existing', 'grid-child'].includes(state.dragging.kind)) return; const drag = state.dragging; const moved = drag.kind === 'new' ? { block: createBlock(drag.type) } : takeDraggedBlock(drag); if (!moved) return; block.columns[columnIndex].blocks.push(moved.block); clearDragState(); syncRaw(); render(); setStatus(drag.kind === 'new' ? 'Added to grid' : 'Moved into grid'); });
                    columns.append(column);
                  }
                  controls.append(responsive, columns); body.querySelector('.block-label').textContent = 'Grid'; body.append(controls);
                }
                else if (block.type === 'image') { const fields = document.createElement('div'); fields.className = 'media-fields'; const url = document.createElement('input'); url.value = block.value; url.placeholder = 'Image URL'; url.setAttribute('aria-label', 'Image URL'); url.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); const picker = document.createElement('button'); picker.type = 'button'; picker.className = 'media-picker-button'; picker.textContent = 'Choose from gallery'; picker.addEventListener('click', () => openMediaPicker('image', value => updateBlock(block.id, 'value', value))); fields.append(url, picker); const alt = document.createElement('input'); alt.value = block.alt || ''; alt.placeholder = 'Alt text'; alt.setAttribute('aria-label', 'Image alt text'); alt.addEventListener('input', e => updateBlock(block.id, 'alt', e.target.value)); fields.append(alt); body.querySelector('.block-label').textContent = 'Image'; body.append(fields); }
                else if (block.type === 'video') { renderVideoControl(body, block, (key, value) => updateBlock(block.id, key, value)); body.querySelector('.block-label').textContent = 'Video'; }
                else if (block.type === 'custom') { const fields = document.createElement('div'); fields.className = 'custom-fields'; const name = document.createElement('input'); name.value = block.name || 'CustomBlock'; name.placeholder = 'Component name'; name.setAttribute('aria-label', 'Custom component name'); name.addEventListener('input', e => updateBlock(block.id, 'name', e.target.value)); const args = document.createElement('input'); args.value = block.value; args.placeholder = 'Arguments, e.g. id: 123'; args.setAttribute('aria-label', 'Custom component arguments'); args.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); fields.append(name, args); body.querySelector('.block-label').textContent = 'Custom block'; body.append(fields); }
                else { const toolbar = document.createElement('div'); toolbar.className = 'format-toolbar'; toolbar.setAttribute('aria-label', 'Text formatting'); toolbar.innerHTML = '<button type="button" data-format="bold" title="Bold"><strong>B</strong></button><button type="button" data-format="italic" title="Italic"><em>I</em></button><button type="button" data-format="underline" title="Underline"><u>U</u></button><button type="button" data-format="strike" title="Strikethrough"><del>S</del></button><button type="button" data-format="link" title="Add link">↗</button>'; const field = document.createElement('textarea'); field.value = block.value; field.placeholder = 'Write text…'; field.setAttribute('aria-label', 'Text with Markdown formatting'); configureTextEditor(field); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.append(toolbar, field); toolbar.querySelectorAll('[data-format]').forEach(button => button.addEventListener('click', () => formatSelection(field, block.id, button.dataset.format))); }
                item.addEventListener('dragstart', event => { if (event.target.closest('.contact-form-component-toolbar')) { event.stopPropagation(); return; } state.dragging = { kind: 'existing', id: block.id }; item.classList.add('dragging'); }); item.addEventListener('dragend', clearDragState);
                item.addEventListener('dragover', e => { if (!state.dragging || !['new', 'existing', 'grid-child'].includes(state.dragging.kind) || (state.dragging.kind === 'existing' && state.dragging.id === block.id)) return; e.preventDefault(); const after = e.clientY > item.getBoundingClientRect().top + item.offsetHeight / 2; placeMarker(item, after); canvas.classList.add('drag-over'); });
                item.addEventListener('drop', e => { if (!state.dragging || !['new', 'existing', 'grid-child'].includes(state.dragging.kind)) return; e.preventDefault(); const drag = state.dragging; const after = e.clientY > item.getBoundingClientRect().top + item.offsetHeight / 2; let to = state.blocks.findIndex(b => b.id === block.id) + (after ? 1 : 0); if (drag.kind === 'new') { state.blocks.splice(to, 0, createBlock(drag.type)); setStatus('Added'); } else if (drag.kind === 'existing' || drag.kind === 'grid-child') { const moved = takeDraggedBlock(drag); if (!moved) return; if (drag.kind === 'existing' && moved.index < to) to--; state.blocks.splice(to, 0, moved.block); setStatus(drag.kind === 'grid-child' ? 'Moved out of grid' : 'Rearranged'); } syncRaw(); clearDragState(); render(); });
                canvas.append(item);
              });
            }
            function insertContactFormChild(container, child) { container.children = container.children || []; if (state.insertPosition === 'top') container.children.unshift(child); else container.children.push(child); container.mode = 'custom'; syncRaw(); render(); setStatus('Added to contact form'); }
            function createBlock(type) { if (type === 'grid') return makeGridBlock(); const definition = editorExtension(type); const block = newBlock(type); if (definition?.isContainer) { block.mode = 'automatic'; block.children = []; } if (type === 'code') block.language = ''; if (type === 'image') block.alt = ''; if (type === 'video') block.kind = 'file'; if (type === 'blockquote') block.cite = ''; if (type === 'custom') block.name = ''; return block; }
            function cloneBlock(block) { const clone = JSON.parse(JSON.stringify(block)); const refreshIDs = item => { item.id = crypto.randomUUID(); (item.children || []).forEach(refreshIDs); (item.columns || []).forEach(column => (column.blocks || []).forEach(refreshIDs)); }; refreshIDs(clone); return clone; }
            function takeDraggedBlock(drag) { if (drag.kind === 'existing') { const index = state.blocks.findIndex(block => block.id === drag.id); return index < 0 ? null : { block: state.blocks.splice(index, 1)[0], index }; } if (drag.kind === 'grid-child') { const grid = state.blocks.find(block => block.id === drag.gridId); if (!grid || !grid.columns[drag.columnIndex]) return null; const column = grid.columns[drag.columnIndex].blocks; return drag.childIndex < 0 ? null : { block: column.splice(drag.childIndex, 1)[0], index: -1 }; } return null; }
            function placeMarker(item, after) { const position = `${item.dataset.id}:${after ? 'after' : 'before'}`; if (marker.dataset.position !== position) { if (after) item.after(marker); else item.before(marker); marker.dataset.position = position; } marker.classList.add('visible'); }
            function clearDragState() { state.dragging = null; marker.classList.remove('visible'); marker.dataset.position = ''; canvas.classList.remove('drag-over'); document.querySelectorAll('.component-button').forEach(button => button.classList.remove('dragging')); document.querySelectorAll('.grid-column, .grid-child').forEach(element => element.classList.remove('drop-target', 'dragging')); }
            canvas.addEventListener('dragover', e => {
              if (!state.dragging || !['new', 'existing', 'grid-child'].includes(state.dragging.kind) || e.target.closest('.block')) return;
              e.preventDefault();
              e.dataTransfer.dropEffect = state.dragging.kind === 'new' ? 'copy' : 'move';
              if (marker.classList.contains('visible')) return;
              canvas.append(marker);
              marker.dataset.position = 'canvas-end';
              marker.classList.add('visible');
              canvas.classList.add('drag-over');
            });
            canvas.addEventListener('drop', e => { if (!state.dragging || !['new', 'existing', 'grid-child'].includes(state.dragging.kind) || e.target.closest('.block')) return; e.preventDefault(); const drag = state.dragging; let to = state.blocks.length; const position = marker.dataset.position; const targetMatch = position && position.match(/^([^:]+):(before|after)$/); if (targetMatch) { to = state.blocks.findIndex(block => block.id === targetMatch[1]) + (targetMatch[2] === 'after' ? 1 : 0); } if (drag.kind === 'existing') { const from = state.blocks.findIndex(b => b.id === drag.id); if (from >= 0) { const [moved] = state.blocks.splice(from, 1); if (from < to) to--; state.blocks.splice(to, 0, moved); } } else if (drag.kind === 'new') state.blocks.splice(to, 0, createBlock(drag.type)); syncRaw(); clearDragState(); render(); setStatus(drag.kind === 'new' ? 'Added' : 'Rearranged'); });
            function showMode(mode) { state.mode = mode; document.querySelector('#visualView').hidden = mode !== 'visual'; document.querySelector('#previewView').hidden = mode !== 'preview'; document.querySelector('#rawView').hidden = mode !== 'raw'; document.querySelector('.component-toolbar').hidden = mode !== 'visual'; document.querySelector('.insert-toggle').hidden = mode !== 'visual'; document.querySelectorAll('[data-mode]').forEach(button => button.classList.toggle('active', button.dataset.mode === mode)); if (mode === 'raw') { syncRaw(); requestAnimationFrame(resizeMarkdownInput); } if (mode === 'preview') renderPreview(); }
            document.querySelectorAll('[data-mode]').forEach(button => button.addEventListener('click', () => { if (state.mode === 'raw' && button.dataset.mode !== 'raw') { state.blocks = parseMarkdown(input.value); render(); } showMode(button.dataset.mode); }));
            function formatSelection(field, id, format) { const start = field.selectionStart; const end = field.selectionEnd; if (start === end) return; const selected = field.value.slice(start, end); const wrappers = { bold: ['**', '**'], italic: ['*', '*'], underline: ['__', '__'], strike: ['~~', '~~'] }; let before; let after; if (format === 'link') { const url = window.prompt('Link URL', 'https://'); if (!url) return; before = '['; after = `](${url})`; } else { [before, after] = wrappers[format]; } const value = field.value.slice(0, start) + before + selected + after + field.value.slice(end); updateBlock(id, 'value', value); field.value = value; field.focus(); field.setSelectionRange(start + before.length, end + before.length); setStatus('Formatted'); }
            const componentList = document.querySelector('.component-list');
            editorExtensions.forEach(definition => {
              if (definition.isContainerChild) return;
              if (!componentList || componentList.querySelector(`[data-add="${definition.type}"]`)) return;
              const button = document.createElement('button'); button.type = 'button'; button.className = 'component-button'; button.dataset.add = definition.type;
              const icon = document.createElement('span'); icon.className = 'component-icon'; icon.textContent = definition.icon; icon.setAttribute('aria-hidden', 'true');
              const title = document.createElement('span'); title.textContent = definition.title;
              const description = document.createElement('small'); description.textContent = definition.title;
              button.append(icon, title, description); componentList.append(button);
            });
            document.querySelectorAll('.component-button').forEach(button => { const description = button.querySelector('small'); if (description) button.title = description.textContent; });
            document.querySelectorAll('[data-insert]').forEach(button => button.addEventListener('click', () => { state.insertPosition = button.dataset.insert; document.querySelectorAll('[data-insert]').forEach(option => option.classList.toggle('active', option === button)); }));
            document.querySelectorAll('[data-add]').forEach(button => { button.draggable = true; button.addEventListener('click', () => { const block = createBlock(button.dataset.add); if (state.insertPosition === 'top') state.blocks.unshift(block); else state.blocks.push(block); syncRaw(); render(); setStatus('Added'); }); button.addEventListener('dragstart', e => { e.dataTransfer.effectAllowed = 'copy'; e.dataTransfer.setData('text/plain', button.dataset.add); state.dragging = { kind: 'new', type: button.dataset.add }; button.classList.add('dragging'); canvas.classList.add('drag-over'); }); button.addEventListener('dragend', clearDragState); });
            input.closest('form')?.addEventListener('submit', event => { if (state.mode === 'raw') state.blocks = parseMarkdown(input.value); const invalid = state.blocks.find(block => editorExtension(block.type)?.isContainer && block.mode === 'custom' && validateContactFormLayout(block).length); if (!invalid) return; event.preventDefault(); render(); const message = validateContactFormLayout(invalid)[0]; setStatus(message); canvas.scrollIntoView({ behavior: 'smooth', block: 'center' }); });
            input.value = initialMarkdown; state.blocks = parseMarkdown(initialMarkdown); render();

        }
        """#

    public func rules() -> [any CSS.Rule] {
        let root = ".admin-rich-content-editor"

        let baseSelectors: [any CSS.Selector] = [
            Custom("\(root)") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
                Width(100.percent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) > .admin-media-picker > label") {
                Display(.none)
            },
            Custom(
                "\(root) > .admin-media-picker > [data-media-picker-open]"
            ) {
                Display(.none)
            },
            Custom(
                "\(root) > .admin-media-picker .admin-media-picker__actions"
            ) {
                Display(.none)
            },
            Custom("\(root) *") {
                BoxSizing(.borderBox)
            },
            Custom("\(root) .workspace") {
                Display(.grid)
                Gap(18.px)
                AlignItems(.flexStart)
                Width(100.percent)
            },
            Custom("\(root) .panel") {
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(12.px)
            },
            Custom("\(root) .sidebar") {
                Padding(vertical: 16.px, horizontal: 18.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom("\(root) .editor") {
                MinWidth(0.px)
                Overflow(.hidden)
            },
            Custom("\(root) .eyebrow") {
                Margin(bottom: 12.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.72.rem)
                FontWeight(.number(700))
                LetterSpacing(0.1.em)
                TextTransform(.uppercase)
            },
            Custom("\(root) .component-list") {
                Display(.grid)
                GridTemplateColumns(.repeat(6, .fraction(1.fr)))
                Gap(10.px)
            },
            Custom("\(root) .component-toolbar") {
                Display(.flex)
                FlexDirection(.column)
                Gap(10.px)
                Padding(10.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
            },
            Custom("\(root) .component-toolbar[hidden]") {
                Display(.none)
            },
            Custom("\(root) .component-button") {
                Display(.grid)
                GridTemplateColumns(
                    .tracks([.length(26.px), .fraction(1.fr)])
                )
                AlignItems(.center)
                Gap(6.px)
                MinWidth(0.px)
                MinHeight(38.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Padding(vertical: 6.px, horizontal: 8.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                TextAlign(.left)
                Cursor(.grab)
            },
            Custom("\(root) .component-button:hover") {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            },
            Custom("\(root) .component-button:active") {
                Cursor(.grabbing)
            },
            Custom("\(root) .component-button small") {
                Display(.none)
            },
            Custom("\(root) .component-icon") {
                Display(.grid)
                AlignItems(.center)
                JustifyContent(.center)
                Width(26.px)
                Height(26.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(6.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Link.default))
                FontSize(0.75.rem)
                FontWeight(.number(800))
                LineHeight(1)
            },
            Custom("\(root) .insert-toggle") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
            },
            Custom("\(root) .insert-toggle[hidden]") {
                Display(.none)
            },
            Custom("\(root) #status.sr-only") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Padding(0)
                Margin((-1).px)
                Overflow(.hidden)
                Clip(.shape("rect(0, 0, 0, 0)"))
                WhiteSpace(.nowrap)
                Border(0)
            },
            Custom("\(root) .insert-toggle strong") {
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) .editor-bar") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                FlexWrap(.wrap)
                Gap(10.px)
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                Padding(10.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.82.rem)
            },
            Custom("\(root) .mode-switch, \(root) .insert-options") {
                Display(.inlineFlex)
                AlignItems(.center)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                MaxWidth(100.percent)
                Gap(2.px)
                Padding(3.px)
                BorderRadius(10.px)
            },
            Custom(
                "\(root) .mode-switch button, \(root) .insert-options button"
            ) {
                Border(0)
                BorderRadius(7.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Padding(vertical: 5.px, horizontal: 10.px)
                FontSize(0.84.rem)
                LineHeight(1.2)
                TextAlign(.center)
                Cursor(.pointer)
                TextDecoration(.none)
                WhiteSpace(.nowrap)
            },
            Custom(
                "\(root) .mode-switch button:hover:not(.active), \(root) .insert-options button:hover:not(.active)"
            ) {
                Color(.variable(TokenKey.Colors.Link.hover))
                TextDecoration(.underline)
            },
            Custom(
                "\(root) .mode-switch button.active, \(root) .insert-options button.active"
            ) {
                Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                Color(.variable(TokenKey.Colors.Accents.Primary.text))
            },
            Custom("\(root) .mode-switch") {
                Display(.inlineFlex)
                AlignItems(.center)
                MaxWidth(100.percent)
            },
            Custom("\(root) .visual-canvas") {
                MinHeight(560.px)
                Padding(10.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom("\(root) .visual-canvas.drag-over") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom("\(root) .visual-canvas > .block") {
                Margin(top: 6.px)
            },
            Custom("\(root) .block") {
                Position(.relative)
                Display(.grid)
                GridTemplateColumns(
                    .tracks([.length(25.px), .fraction(1.fr)])
                )
                Gap(10.px)
                AlignItems(.flexStart)
                Border(1.px, .solid, .transparent)
                BorderRadius(9.px)
                Padding(vertical: 12.px, horizontal: 8.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            },
            Custom("\(root) .block:hover, \(root) .block.dragging") {
                BorderColor(.variable(TokenKey.Colors.Materials.Primary.border))
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            },
            Custom("\(root) .drag-controls") {
                Display(.grid)
                Gap(3.px)
            },
            Custom("\(root) .drag-handle") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(1.1.rem)
                Cursor(.grab)
                UserSelect(.none)
            },
            Custom("\(root) .move-button, \(root) .duplicate-button, \(root) .remove") {
                Border(0)
                BorderRadius(6.px)
                Padding(3.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Cursor(.pointer)
            },
            Custom("\(root) .remove") {
                Position(.absolute)
                Top(8.px)
                Right(8.px)
                Width(28.px)
                Height(28.px)
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.center)
                BoxSizing(.borderBox)
            },
            Custom("\(root) .move-button:hover, \(root) .duplicate-button:hover, \(root) .remove:hover") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
                Color(.variable(TokenKey.Colors.Link.default))
            },
            Custom("\(root) .duplicate-button") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(24.px)
                Height(24.px)
            },
            Custom("\(root) .duplicate-button svg") {
                Width(16.px)
                Height(16.px)
            },
            Custom("\(root) .remove.is-confirming") {
                Width(76.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                FontSize(0.75.rem)
                FontWeight(.number(600))
                WhiteSpace(.nowrap)
            },
            Custom("\(root) .block-body") {
                MinWidth(0.px)
            },
            Custom("\(root) .block-label") {
                Display(.block)
                Margin(bottom: 5.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.65.rem)
                FontWeight(.number(700))
                LetterSpacing(0.08.em)
                TextTransform(.uppercase)
            },
            Custom("\(root) .block input, \(root) .block textarea") {
                Width(100.percent)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Padding(vertical: 9.px, horizontal: 11.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Outline(0)
            },
            Custom("\(root) .block textarea") {
                UnsafeRawProperty(name: "min-height", value: "12lh")
                Resize(.none)
            },
            Custom("\(root) .block textarea.text-editor") {
                UnsafeRawProperty(name: "min-height", value: "3lh")
                UnsafeRawProperty(name: "overflow-y", value: "hidden")
                Resize(.none)
            },
            Custom("\(root) .block textarea.code-editor") {
                Display(.block)
                Margin(top: 8.px)
            },
            Custom("\(root) .block input.code-language") {
                Display(.block)
            },
            Custom(
                "\(root) .block input:focus, \(root) .block textarea:focus, \(root) #markdownInput:focus"
            ) {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BoxShadow(.none)
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
            Custom("\(root) .format-toolbar, \(root) .heading-toolbar") {
                Display(.flex)
                Gap(4.px)
                Margin(bottom: 6.px)
            },
            Custom(
                "\(root) .format-toolbar button, \(root) .heading-toolbar button"
            ) {
                MinWidth(29.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(6.px)
                Padding(vertical: 4.px, horizontal: 7.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Cursor(.pointer)
            },
            Custom(
                "\(root) .format-toolbar button:hover, \(root) .heading-toolbar button:hover, \(root) .heading-toolbar button.active"
            ) {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Link.default))
            },
            Custom(
                "\(root) .media-picker-button, \(root) .embed-picker-button"
            ) {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                BoxSizing(.borderBox)
                UnsafeRawProperty(name: "font", value: "inherit")
                FontWeight(.normal)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Buttons.Ghost.Primary.border)
                )
                BorderRadius(6.px)
                Padding(vertical: 7.px, horizontal: 10.px)
                Background(
                    .variable(TokenKey.Colors.Buttons.Ghost.Primary.tint)
                )
                Color(.variable(TokenKey.Colors.Buttons.Ghost.Primary.text))
                Cursor(.pointer)
                TextDecoration(.none)
            },
            Custom(
                "\(root) .media-picker-button:hover, \(root) .embed-picker-button:hover"
            ) {
                Background(
                    .variable(TokenKey.Colors.Buttons.Ghost.Primary.hover)
                )
            },
            Custom("\(root) #rawView") {
                Padding(10.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom("\(root) #markdownInput") {
                Display(.block)
                Width(100.percent)
                MinHeight(560.px)
                Resize(.none)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Padding(10.px)
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Outline(0)
                UnsafeRawProperty(
                    name: "font",
                    value:
                        "14px/1.7 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
                )
            },
            Custom("\(root) #previewView") {
                MinHeight(560.px)
                Padding(10.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom("\(root) .preview-content") {
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom(
                "\(root) .preview-content h1, \(root) .preview-content h2, \(root) .preview-content h3, \(root) .preview-content h4, \(root) .preview-content h5, \(root) .preview-content h6"
            ) {
                Margin(bottom: 12.px)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom(
                "\(root) .preview-content p, \(root) .preview-content ul, \(root) .preview-content ol, \(root) .preview-content blockquote, \(root) .preview-content pre"
            ) {
                Margin(bottom: 22.px)
            },
            Custom("\(root) .preview-content a") {
                Color(.variable(TokenKey.Colors.Link.default))
            },
            Custom(
                "\(root) .preview-content img, \(root) .preview-content video, \(root) .preview-content iframe"
            ) {
                Display(.block)
                MaxWidth(100.percent)
                Margin(top: 8.px, bottom: 22.px)
                BorderRadius(9.px)
            },
            Custom("\(root) .preview-content iframe") {
                Width(100.percent)
                UnsafeRawProperty(name: "aspect-ratio", value: "16 / 9")
                Border(0)
            },
            Custom("\(root) .preview-content pre") {
                OverflowX(.auto)
                Padding(16.px)
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            },
            Custom("\(root) .preview-empty, \(root) .empty") {
                Padding(vertical: 105.px, horizontal: 20.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                TextAlign(.center)
            },
            Custom(
                "\(root) .media-fields, \(root) .embed-fields, \(root) .custom-fields, \(root) .quote-fields, \(root) .grid-settings"
            ) {
                Display(.grid)
                Gap(8.px)
            },
            Custom("\(root) .grid-responsive") {
                Display(.flex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(12.px)
            },
            Custom("\(root) .grid-setting") {
                Display(.flex)
                AlignItems(.center)
                Gap(6.px)
                WhiteSpace(.nowrap)
                FontSize(0.8.rem)
                FontWeight(.number(600))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            },
            Custom("\(root) .grid-responsive .grid-setting-input") {
                Width(3.25.rem)
                MinWidth(3.25.rem)
                Padding(vertical: 6.px, horizontal: 5.px)
                TextAlign(.center)
            },
            Custom("\(root) .embed-fields") {
                Margin(bottom: 8.px)
            },
            Custom("\(root) .grid-columns") {
                Display(.grid)
                GridTemplateColumns(.repeat(3, .fraction(1.fr)))
                Gap(8.px)
            },
            Custom("\(root) .grid-child") {
                MinWidth(0.px)
            },
            Custom("\(root) .grid-column") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
                MinHeight(82.px)
                Padding(8.px)
            },
            Custom("\(root) .grid-column > label") {
                Display(.block)
                Margin(bottom: 10.px)
            },
            Custom("\(root) .grid-column, \(root) .contact-form-layout-children") {
                Border(
                    1.px,
                    .dashed,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom("\(root) .contact-form-layout-editor") {
                Display(.flex)
                FlexDirection(.column)
                Gap(12.px)
                MarginTop(12.px)
                Padding(12.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom("\(root) .contact-form-mode-switch") {
                Margin(top: 8.px, bottom: 12.px)
            },
            Custom("\(root) .contact-form-toolbar-heading, \(root) .contact-form-toolbar-separator") {
                GridColumn(.span(6))
            },
            Custom("\(root) .contact-form-toolbar-heading") {
                Margin(vertical: 4.px, horizontal: 0.px)
            },
            Custom("\(root) .contact-form-toolbar-separator") {
                Border(0)
                BorderTop(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Margin(vertical: 4.px, horizontal: 0.px)
            },
            Custom("\(root) .contact-form-field-preview, \(root) .contact-form-marker-preview") {
                Display(.flex)
                FlexDirection(.column)
                Gap(5.px)
            },
            Custom("\(root) .contact-form-field-preview code") {
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            },
            Custom("\(root) .contact-form-field-option") {
                Cursor(.grab)
            },
            Custom("\(root) .contact-form-field-option:disabled") {
                Opacity(0.45)
                Cursor(.default)
            },
            Custom("\(root) .contact-form-layout-children") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
                MinHeight(360.px)
                Padding(12.px)
            },
            Custom("\(root) .contact-form-layout-empty") {
                MinHeight(70.px)
                Display(.grid)
                AlignItems(.center)
                JustifyContent(.center)
                Padding(10.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                TextAlign(.center)
            },
            Custom("\(root) .contact-form-layout-children.drop-target .contact-form-layout-empty") {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom("\(root) .contact-form-palette-status") {
                GridColumn(.span(6))
                Margin(0.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Custom("\(root) .contact-form-layout-validation, \(root) .contact-form-layout-note") {
                Margin(0.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Custom("\(root) .contact-form-layout-validation") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Custom("\(root) .contact-form-grid-source") {
                MinHeight(130.px)
                Width(100.percent)
            },
            Custom("\(root) .contact-form-grid-editor") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            },
            Custom("\(root) .contact-form-grid-column") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
                MinHeight(82.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom(
                "\(root) .grid-column.drop-target, \(root) .contact-form-grid-column.drop-target, \(root) .contact-form-layout-children.drop-target, \(root) .grid-child.drop-target, \(root) .contact-form-layout-child.drop-target"
            ) {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom("\(root) .drop-marker") {
                Height(4.px)
                Margin(vertical: 5.px, horizontal: 4.px)
                BorderRadius(5.px)
                Background(.variable(TokenKey.Colors.Link.default))
                Opacity(0)
                PointerEvents(.none)
            },
            Custom("\(root) .drop-marker.visible") {
                Opacity(1)
            },
            Custom("\(root) dialog.mce-embed-picker") {
                Position(.fixed)
                Top(0.px)
                Right(0.px)
                Bottom(0.px)
                Left(0.px)
                ZIndex(.number(20))
                Width(100.percent)
                Height(100.vh)
                MaxWidth(100.percent)
                MaxHeight(100.vh)
                Margin(0.px)
                Border(0)
                BorderRadius(0.px)
                Overflow(.visible)
                Padding(24.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) dialog.mce-embed-picker[open]") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.center)
            },
            Custom("\(root) dialog.mce-embed-picker::backdrop") {
                Background(
                    color: .color(
                        CSSColor(stringLiteral: "rgba(128, 128, 128, 0.46)")
                    )
                )
                BackdropFilter(.blur(12.px))
            },
            Custom(
                "html.admin-dialog-open, html.admin-dialog-open body"
            ) {
                Overflow(.hidden)
            },
            Custom("\(root) .mce-embed-picker-dialog") {
                Position(.relative)
                ZIndex(.number(1))
                Display(.flex)
                FlexDirection(.column)
                Gap(18.px)
                Width(92.percent)
                MaxWidth(640.px)
                MaxHeight(90.vh)
                Overflow(.auto)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
                BorderRadius(18.px)
                Padding(24.px)
                Background(
                    color: .color(CSSColor(stringLiteral: "#ffffff"))
                )
                BoxShadow(
                    0.px,
                    18.px,
                    blur: 48.px,
                    spread: 0.px,
                    color: CSSColor(stringLiteral: "rgba(0, 0, 0, 0.24)")
                )
            },
            Custom(
                "\(root) .mce-embed-picker-header, \(root) .mce-embed-picker-search"
            ) {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
            },
            Custom("\(root) .mce-embed-picker-header") {
                JustifyContent(.spaceBetween)
                Gap(16.px)
            },
            Custom("\(root) .mce-embed-picker-header h2") {
                Margin(0.px)
                FontSize(1.35.rem)
                LineHeight(1.2)
            },
            Custom("\(root) .mce-embed-picker-close") {
                FlexShrink(0)
            },
            Custom("\(root) .mce-embed-picker-search") {
                Margin(bottom: 12.px)
            },
            Custom("\(root) .mce-embed-picker-search input") {
                MinWidth(0.px)
                FlexGrow(1)
            },
            Custom(
                "\(root) .mce-embed-picker-search input, \(root) .mce-embed-picker-search button, \(root) .mce-embed-picker-list button"
            ) {
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(7.px)
                Padding(vertical: 8.px, horizontal: 9.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) .mce-embed-picker-list") {
                Display(.grid)
                Gap(7.px)
            },
            Custom("\(root) .mce-embed-picker-list button") {
                TextAlign(.left)
                Cursor(.pointer)
            },
        ]

        return [
            Media {
                for selector in baseSelectors {
                    selector
                }
            },
            Media(.prefersColorScheme(.dark)) {
                Custom("\(root) dialog.mce-embed-picker::backdrop") {
                    Background(
                        color: .color(
                            CSSColor(stringLiteral: "rgba(0, 0, 0, 0.68)")
                        )
                    )
                }
                Custom("\(root) .mce-embed-picker-dialog") {
                    Background(
                        .variable(TokenKey.Colors.Materials.Primary.tint)
                    )
                }
            },
            Media(.maxWidth(900.px)) {
                Custom("\(root) .component-list") {
                    GridTemplateColumns(.repeat(3, .fraction(1.fr)))
                }
                Custom("\(root) .grid-columns") {
                    GridTemplateColumns(.repeat(2, .fraction(1.fr)))
                }
            },
            Media(.maxWidth(600.px)) {
                Custom("\(root) .component-list") {
                    GridTemplateColumns(.repeat(2, .fraction(1.fr)))
                }
                Custom("\(root) .grid-columns") {
                    GridTemplateColumns(.fraction(1.fr))
                }
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(AdminFormFieldLabel(text: state.label))
            Div {
                Div {
                    Div {
                        Nav {
                            Button("Visual")
                                .type(.button)
                                .class("active")
                                .setAttribute(
                                    name: "data-mode",
                                    value: "visual"
                                )
                            Button("Markdown")
                                .type(.button)
                                .setAttribute(
                                    name: "data-mode",
                                    value: "raw"
                                )
                            Button("Preview")
                                .type(.button)
                                .setAttribute(
                                    name: "data-mode",
                                    value: "preview"
                                )
                        }
                        .class("mode-switch")
                        Div {
                            Strong("Insert at")
                            Div {
                                Button("Bottom")
                                    .type(.button)
                                    .class("active")
                                    .setAttribute(
                                        name: "data-insert",
                                        value: "bottom"
                                    )
                                Button("Top")
                                    .type(.button)
                                    .setAttribute(
                                        name: "data-insert",
                                        value: "top"
                                    )
                            }
                            .class("insert-options")
                        }
                        .class("insert-toggle")
                    }
                    .class("editor-bar")
                    Div {
                        Div {
                            for definition in blockDefinitions {
                                Button {
                                    Span(definition.icon)
                                        .class("component-icon")
                                        .setAttribute(
                                            name: "aria-hidden",
                                            value: "true"
                                        )
                                    Span(definition.title)
                                    Small(definition.title)
                                }
                                .type(.button)
                                .class("component-button")
                                .setAttribute(
                                    name: "data-add",
                                    value: definition.type
                                )
                            }
                        }
                        .class("component-list")
                    }
                    .class("component-toolbar")
                    Span("")
                        .id("status")
                        .class("sr-only")
                        .setAttribute(name: "aria-live", value: "polite")
                    Div {
                        Div {}
                            .id("canvas")
                            .class("visual-canvas")
                    }
                    .id("visualView")
                    Div {
                        Div {}.id("previewContent").class("preview-content")
                    }
                    .id("previewView")
                    .hidden()
                    Div {
                        Textarea(state.value ?? "")
                            .id("markdownInput")
                            .name(state.key)
                            .rows(3)
                            .setAttribute(
                                name: "placeholder",
                                value: "Write Markdown…"
                            )
                            .setAttribute(name: "spellcheck", value: "false")
                            .setAttribute(
                                name: "data-media-base-url",
                                value: "/media/"
                            )
                            .class("markdown-source")
                    }
                    .id("rawView")
                    .hidden()
                }
                .class("panel", "editor")
            }
            .class(
                "workspace",
                "mce-app",
                "admin-rich-content-editor"
            )
            .data("markdown-image-picker", "markdown-image-url")
            .data("markdown-video-picker", "markdown-video-url")
            .data(
                "markdown-media-base-url",
                "/media/"
            )
            context.build(
                AdminFormFieldMediaPicker(
                    state: .init(
                        field: .init(
                            key: "markdown-image-url",
                            label: "Choose image",
                            value: nil,
                            error: nil
                        ),
                        selectedAsset: nil,
                        browsePath:
                            "/admin/media/assets/?picker=1&field=markdown-image-url&extensions=\(AllowedExtensions.images.queryValue)",
                        defaultFolderPath: state.mediaFolderPath,
                        allowedExtensions: .images,
                        outputMode: .relativeURL,
                        showsCurrentCard: false,
                        previewStyle: .wide
                    )
                )
            )
            context.build(
                AdminFormFieldMediaPicker(
                    state: .init(
                        field: .init(
                            key: "markdown-video-url",
                            label: "Choose video",
                            value: nil,
                            error: nil
                        ),
                        selectedAsset: nil,
                        browsePath:
                            "/admin/media/assets/?picker=1&field=markdown-video-url&extensions=\(AllowedExtensions.videos.queryValue)",
                        defaultFolderPath: state.mediaFolderPath,
                        allowedExtensions: .videos,
                        outputMode: .relativeURL,
                        showsCurrentCard: false,
                        previewStyle: .wide
                    )
                )
            )
            if let error = state.error {
                Span(error).class("field-error")
            }
            Script(Self.markdownEditorScript)
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("admin-rich-content-editor")
    }
}
