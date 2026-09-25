public import CSS
import Foundation
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminFormFieldRichContentEditor: Component {
    public struct State: Sendable {
        public let key: String
        public let label: String
        public let value: String?
        public let error: String?

        public init(
            key: String,
            label: String,
            value: String?,
            error: String?
        ) {
            self.key = key
            self.label = label
            self.value = value
            self.error = error
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
        .init(title: "Grid", icon: "▦", type: "grid"),
        .init(title: "Blockquote", icon: "“", type: "blockquote"),
        .init(title: "Code block", icon: "{}", type: "code"),
        .init(title: "HTML", icon: "<>", type: "html"),
        .init(title: "Newsletter", icon: "✉", type: "newsletter"),
        .init(title: "Contact form", icon: "☏", type: "contact-form"),
        .init(title: "Custom block", icon: "✦", type: "custom"),
    ]

    private static let markdownEditorScript = #"""
    if (document.querySelector('#markdownInput')) {
        const initialMarkdown = document.querySelector('#markdownInput').defaultValue || document.querySelector('#markdownInput').value;
        const state = { blocks: [], mode: 'visual', dragging: null, insertPosition: 'bottom' };
        const canvas = document.querySelector('#canvas');
        const previewContent = document.querySelector('#previewContent');
        const input = document.querySelector('#markdownInput');
        const status = document.querySelector('#status');
        const marker = document.createElement('div'); marker.className = 'drop-marker';

        function newBlock(type, value = '') { return { id: crypto.randomUUID(), type, value, url: '', level: 2 }; }
        function splitMarkdownBlocks(markdown) {
          const lines = markdown.replace(/\r/g, '').split('\n'); const blocks = []; let current = []; let fenced = false; let gridDepth = 0;
          lines.forEach(line => { const trimmed = line.trim(); if (!fenced && /^```/.test(trimmed)) { if (current.length) { blocks.push(current.join('\n').trim()); current = []; } fenced = true; current.push(line); } else if (fenced) { current.push(line); if (trimmed === '```') { blocks.push(current.join('\n').trim()); current = []; fenced = false; } } else if (gridDepth > 0) { current.push(line); gridDepth += (line.match(/\{/g) || []).length - (line.match(/\}/g) || []).length; if (gridDepth === 0) { blocks.push(current.join('\n').trim()); current = []; } } else if (current.length && /^@Grid\(/.test(current[0].trim()) && line.includes('{')) { current.push(line); gridDepth = (current.join('\n').match(/\{/g) || []).length - (current.join('\n').match(/\}/g) || []).length; if (gridDepth === 0) { blocks.push(current.join('\n').trim()); current = []; } } else if (!trimmed) { if (current.length) { blocks.push(current.join('\n').trim()); current = []; } } else { current.push(line); if (current.length === 1 && /^@Grid\(/.test(trimmed) && line.includes('{')) { gridDepth = (line.match(/\{/g) || []).length - (line.match(/\}/g) || []).length; if (gridDepth === 0) { blocks.push(current.join('\n').trim()); current = []; } } } });
          if (current.length) blocks.push(current.join('\n').trim()); return blocks;
        }
        function parseMarkdown(markdown) {
          return splitMarkdownBlocks(markdown).filter(Boolean).map(part => {
            const code = part.match(/^```([^\n]*)\n([\s\S]*?)\n?```$/); if (code) return Object.assign(newBlock('code', code[2]), { language: code[1].trim() });
            if (/^-{3,}$/.test(part)) return newBlock('separator', '');
            if (/^(?:[-*+]\s+|\d+\.\s+)/.test(part)) { const ordered = /^\d+\.\s+/.test(part); return newBlock(ordered ? 'ol' : 'ul', part.split('\n').map(line => line.replace(ordered ? /^\d+\.\s+/ : /^[-*+]\s+/, '')).join('\n')); }
            if (/^>/.test(part)) { const lines = part.split('\n').map(line => line.replace(/^>\s?/, '')); const citeIndex = lines.findIndex(line => /^—\s+/.test(line)); const cite = citeIndex >= 0 ? lines.splice(citeIndex, 1)[0].replace(/^—\s+/, '') : ''; return Object.assign(newBlock('blockquote', lines.filter(Boolean).join('\n')), { cite }); }
            const image = part.match(/^!\[([^\]]*)\]\(([^)]+)\)$/); if (image) return Object.assign(newBlock('image', image[2]), { alt: image[1] });
            const video = part.match(/^<video[^>]*\bsrc=["']([^"']+)["'][^>]*>\s*<\/video>$/i); if (video) return Object.assign(newBlock('video', video[1]), { controls: true });
        const newsletter = part.match(/^@NewsletterCampaign\(key:\s*([^\)]+)\)$/); if (newsletter) return newBlock('newsletter', newsletter[1].trim());
        const contactForm = part.match(/^@ContactForm\(key:\s*([^\)]+)\)$/); if (contactForm) return newBlock('contact-form', contactForm[1].trim());
            const grid = part.match(/^@Grid\(([^)]*)\)\s*\{([\s\S]*)\}$/); if (grid) { const settings = { desktop: 3, tablet: 2, mobile: 1 }; grid[1].split(',').forEach(pair => { const match = pair.match(/(desktop|tablet|mobile)\s*:\s*(\d+)/); if (match) settings[match[1]] = Number(match[2]); }); const cells = [...grid[2].matchAll(/@Cell\s*\{([\s\S]*?)\}/g)].map(cell => ({ blocks: parseMarkdown(cell[1].trim()) })); return Object.assign(newBlock('grid', ''), { settings, columnCount: cells.length || 1, columns: cells }); }
            const custom = part.match(/^@([A-Za-z][\w-]*)\(([^]*)\)$/); if (custom) return Object.assign(newBlock('custom', custom[2]), { name: custom[1] });
            const heading = part.match(/^(#{1,6})\s+(.+)$/); if (heading) return Object.assign(newBlock('heading', heading[2]), { level: heading[1].length });
            if (/^<[^>]+[\s\S]*>$/.test(part)) return newBlock('html', part);
            return newBlock('text', part);
          });
        }
        function serializeBlocks(blocks) { return blocks.map(serializeBlock).filter(Boolean).join('\n\n'); }
        function serialize() { return serializeBlocks(state.blocks); }
        function serializeBlock(block) { const value = (block.value || '').trim(); if (!value && !['code', 'grid', 'separator'].includes(block.type)) return ''; if (block.type === 'separator') return '---'; if (block.type === 'heading') return `${'#'.repeat(block.level)} ${value}`; if (block.type === 'code') return '```' + (block.language || '').trim() + '\n' + value + '\n```'; if (block.type === 'ul') return value.split('\n').filter(Boolean).map(item => '- ' + item.trim()).join('\n'); if (block.type === 'ol') return value.split('\n').filter(Boolean).map((item, index) => `${index + 1}. ${item.trim()}`).join('\n'); if (block.type === 'blockquote') return value.split('\n').map(line => '> ' + line).join('\n') + (block.cite ? '\n>\n> — ' + block.cite.trim() : ''); if (block.type === 'image') return `![${(block.alt || '').trim()}](${value})`; if (block.type === 'video') return '<video controls src="' + value + '"></video>'; if (block.type === 'newsletter') return '@NewsletterCampaign(key: ' + value + ')'; if (block.type === 'contact-form') return '@ContactForm(key: ' + value + ')'; if (block.type === 'custom') return '@' + (block.name || '').trim() + '(' + value + ')'; if (block.type === 'grid') { const settings = block.settings || { desktop: 3, tablet: 2, mobile: 1 }; const columns = (block.columns || []).map(column => '@Cell {\n' + serializeBlocks(column.blocks || []) + '\n}').join('\n'); return '@Grid(desktop: ' + settings.desktop + ', tablet: ' + settings.tablet + ', mobile: ' + settings.mobile + ') {\n' + columns + '\n}'; } return value; }
        function setStatus(message) { status.textContent = message; clearTimeout(setStatus.timer); setStatus.timer = setTimeout(() => status.textContent = 'Saved locally in editor', 900); }
        function syncRaw() { input.value = serialize(); }
        function updateBlock(id, key, value) { const block = state.blocks.find(item => item.id === id); if (!block) return; block[key] = value; syncRaw(); setStatus('Updated'); }
        const editorRoot = document.querySelector('.mce-app');
        const mediaBaseURL = input.getAttribute('data-media-base-url') || editorRoot?.dataset.markdownMediaBaseUrl || editorRoot?.getAttribute('data-markdown-media-base-url') || '';
        function mediaURL(value) {
          if (!value || !value.startsWith('/media/assets/') || !mediaBaseURL) return value;
          try { return new URL(value, mediaBaseURL).toString(); } catch (_) { return mediaBaseURL.replace(/\/$/, '') + value; }
        }
        function pickerFieldKey(type) { const app = document.querySelector('.mce-app'); return app && app.getAttribute(`data-markdown-${type}-picker`); }
        function openMediaPicker(type, apply) { const field = pickerFieldKey(type); const trigger = field && document.querySelector(`[data-media-picker-open="${field}"]`); if (!trigger) { setStatus('Gallery picker unavailable'); return; } state.pendingMedia = { apply }; trigger.click(); }
        ['image', 'video'].forEach(type => { const field = pickerFieldKey(type); const pickerInput = field && document.getElementById(field); if (!pickerInput) return; pickerInput.addEventListener('change', () => { if (!state.pendingMedia || !pickerInput.value) return; state.pendingMedia.apply(pickerInput.value); state.pendingMedia = null; render(); }); });
        function openEmbedPicker(type, apply) {
          let modal = document.getElementById('mceEmbedPicker');
          if (!modal) {
            modal = document.createElement('div'); modal.id = 'mceEmbedPicker'; modal.className = 'mce-embed-picker';
            modal.innerHTML = '<div class="mce-embed-picker-dialog"><div class="mce-embed-picker-header"><strong></strong><button type="button" class="button secondary-ghost mce-embed-picker-close" aria-label="Close" title="Close" data-embed-picker-close>Close</button></div><div class="mce-embed-picker-search"><input type="search" placeholder="Search…"><button type="button">Search</button></div><div class="mce-embed-picker-list"></div></div>';
            editorRoot.append(modal);
            modal.querySelector('[data-embed-picker-close]').addEventListener('click', () => modal.classList.remove('is-visible'));
            modal.querySelector('.mce-embed-picker-search button').addEventListener('click', () => loadEmbedPicker(modal));
            modal.querySelector('.mce-embed-picker-search input').addEventListener('keydown', event => { if (event.key === 'Enter') loadEmbedPicker(modal); });
          }
          modal.dataset.embedType = type; modal.__apply = apply;
          modal.classList.add('is-visible');
          loadEmbedPicker(modal);
        }
        async function loadEmbedPicker(modal) {
          const type = modal.dataset.embedType; const search = modal.querySelector('.mce-embed-picker-search input').value.trim();
          const endpoint = type === 'newsletter' ? '/admin/newsletter/campaigns/?picker=1' : '/admin/contact/forms/?picker=1';
          const url = new URL(endpoint, window.location.origin); if (search) url.searchParams.set('search', search);
          const list = modal.querySelector('.mce-embed-picker-list'); list.innerHTML = '<p>Loading…</p>';
          try {
            const response = await fetch(url, { credentials: 'same-origin' }); const html = await response.text();
            const doc = new DOMParser().parseFromString(html, 'text/html'); const items = [...doc.querySelectorAll('[data-mce-picker-item]')];
            list.innerHTML = items.length ? '' : '<p>No matching items.</p>';
            items.forEach(item => { const button = document.createElement('button'); button.type = 'button'; button.textContent = item.getAttribute('data-mce-picker-label') || item.textContent.trim(); button.addEventListener('click', () => { modal.__apply(item.getAttribute('data-mce-picker-item'), button.textContent); modal.classList.remove('is-visible'); render(); }); list.append(button); });
          } catch (_) { list.innerHTML = '<p class="error">Unable to load items.</p>'; }
        }
        function renderEmbedControl(body, block, update) {
          const fields = document.createElement('div'); fields.className = 'embed-fields';
          const key = document.createElement('input'); key.value = block.value || ''; key.placeholder = block.type === 'newsletter' ? 'Newsletter campaign key' : 'Contact form key'; key.setAttribute('aria-label', key.placeholder); key.addEventListener('input', event => update('value', event.target.value));
          const picker = document.createElement('button'); picker.type = 'button'; picker.className = 'embed-picker-button'; picker.textContent = block.value ? 'Change selection' : 'Choose from list'; picker.addEventListener('click', () => openEmbedPicker(block.type, value => { update('value', value); }));
          fields.append(key, picker); body.append(fields);
        }
        function escapeHTML(value) { return value.replace(/[&<>"']/g, character => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[character])); }
        function inlineMarkdown(value) { let html = escapeHTML(value); html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank" rel="noreferrer">$1</a>'); html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>').replace(/__([^_]+)__/g, '<u>$1</u>').replace(/~~([^~]+)~~/g, '<del>$1</del>').replace(/\*([^*]+)\*/g, '<em>$1</em>'); return html; }
        function renderPreviewBlock(block) { let element; if (block.type === 'heading') { element = document.createElement(`h${block.level}`); element.innerHTML = inlineMarkdown(block.value); } else if (block.type === 'text') { element = document.createElement('p'); element.innerHTML = inlineMarkdown(block.value); } else if (block.type === 'separator') element = document.createElement('hr'); else if (block.type === 'ul' || block.type === 'ol') { element = document.createElement(block.type); block.value.split('\n').filter(Boolean).forEach(item => { const li = document.createElement('li'); li.innerHTML = inlineMarkdown(item); element.append(li); }); } else if (block.type === 'blockquote') { element = document.createElement('blockquote'); element.innerHTML = inlineMarkdown(block.value.replace(/\n/g, '<br>')); if (block.cite) { const cite = document.createElement('cite'); cite.textContent = `— ${block.cite}`; element.append(cite); } } else if (block.type === 'image') { element = document.createElement('img'); element.src = mediaURL(block.value); element.alt = block.alt || ''; } else if (block.type === 'video') { element = document.createElement('video'); element.src = mediaURL(block.value); element.controls = true; } else if (block.type === 'code') { element = document.createElement('pre'); const code = document.createElement('code'); code.textContent = block.value; element.append(code); } else if (block.type === 'html') { element = document.createElement('div'); element.innerHTML = block.value; } else if (block.type === 'grid') { const settings = block.settings || { desktop: 3, tablet: 2, mobile: 1 }; element = document.createElement('div'); element.className = 'preview-grid'; element.style.setProperty('--grid-desktop', settings.desktop); element.style.setProperty('--grid-tablet', settings.tablet); element.style.setProperty('--grid-mobile', settings.mobile); (block.columns || []).forEach(column => { const columnElement = document.createElement('div'); columnElement.className = 'preview-grid-column'; (column.blocks || []).forEach(child => columnElement.append(renderPreviewBlock(child))); element.append(columnElement); }); } else { element = document.createElement('pre'); element.className = 'preview-custom'; element.textContent = serializeBlock(block); } return element; }
        function renderPreview() { previewContent.innerHTML = ''; if (!state.blocks.length) { previewContent.innerHTML = '<div class="preview-empty">Nothing to preview yet.</div>'; return; } state.blocks.forEach(block => previewContent.append(renderPreviewBlock(block))); }
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
        function renderBlockContent(body, block, update) {
          if (block.type === 'newsletter' || block.type === 'contact-form') { renderEmbedControl(body, block, update); return; }
          if (block.type === 'heading') { const toolbar = document.createElement('div'); toolbar.className = 'heading-toolbar'; toolbar.setAttribute('aria-label', 'Heading level'); toolbar.innerHTML = [1,2,3,4,5,6].map(level => `<button type="button" class="${level === block.level ? 'active' : ''}" data-level="${level}" title="Heading ${level}">H${level}</button>`).join(''); toolbar.querySelectorAll('[data-level]').forEach(button => button.addEventListener('click', () => { update('level', Number(button.dataset.level)); render(); })); const field = document.createElement('input'); field.value = block.value; field.placeholder = 'Heading text…'; field.setAttribute('aria-label', 'Heading text'); field.addEventListener('input', e => update('value', e.target.value)); body.append(toolbar, field); }
          else if (block.type === 'separator') { const rule = document.createElement('div'); rule.className = 'preview-content'; rule.innerHTML = '<hr>'; body.append(rule); }
          else if (block.type === 'ul' || block.type === 'ol') { const toolbar = document.createElement('div'); toolbar.className = 'format-toolbar'; toolbar.setAttribute('aria-label', 'Text formatting'); toolbar.innerHTML = '<button type="button" data-format="bold" title="Bold"><strong>B</strong></button><button type="button" data-format="italic" title="Italic"><em>I</em></button><button type="button" data-format="underline" title="Underline"><u>U</u></button><button type="button" data-format="strike" title="Strikethrough"><del>S</del></button><button type="button" data-format="link" title="Add link">↗</button>'; const field = document.createElement('textarea'); field.className = 'list-editor'; field.value = block.value; field.placeholder = 'One list item per line…'; field.setAttribute('aria-label', `${block.type === 'ul' ? 'Unordered' : 'Ordered'} list items`); field.addEventListener('input', e => update('value', e.target.value)); body.append(toolbar, field); toolbar.querySelectorAll('[data-format]').forEach(button => button.addEventListener('click', () => formatSelectionForBlock(field, block, update, button.dataset.format))); }
          else if (block.type === 'blockquote') { const fields = document.createElement('div'); fields.className = 'quote-fields'; const quote = document.createElement('textarea'); quote.value = block.value; quote.placeholder = 'Quote text…'; quote.setAttribute('aria-label', 'Blockquote text'); quote.addEventListener('input', e => update('value', e.target.value)); const cite = document.createElement('input'); cite.value = block.cite || ''; cite.placeholder = 'Citation (optional)'; cite.setAttribute('aria-label', 'Blockquote citation'); cite.addEventListener('input', e => update('cite', e.target.value)); fields.append(quote, cite); body.append(fields); }
          else if (block.type === 'html') { const field = document.createElement('textarea'); field.className = 'html-editor'; field.value = block.value; field.placeholder = '<div>Raw HTML…</div>'; field.setAttribute('aria-label', 'Raw HTML'); field.addEventListener('input', e => update('value', e.target.value)); body.append(field); }
          else if (block.type === 'code') { const language = document.createElement('input'); language.className = 'code-language'; language.value = block.language; language.placeholder = 'Language (e.g. swift)'; language.setAttribute('aria-label', 'Code language'); language.addEventListener('input', e => update('language', e.target.value)); const field = document.createElement('textarea'); field.className = 'code-editor'; field.value = block.value; field.placeholder = 'Paste or type code…'; field.setAttribute('aria-label', 'Code'); field.addEventListener('input', e => update('value', e.target.value)); body.append(language, field); }
          else if (block.type === 'image' || block.type === 'video') { const fields = document.createElement('div'); fields.className = 'media-fields'; const url = document.createElement('input'); url.value = block.value; url.placeholder = block.type === 'image' ? 'Image URL' : 'Video URL'; url.setAttribute('aria-label', `${block.type} URL`); url.addEventListener('input', e => update('value', e.target.value)); const picker = document.createElement('button'); picker.type = 'button'; picker.className = 'media-picker-button'; picker.textContent = 'Choose from gallery'; picker.addEventListener('click', () => openMediaPicker(block.type, value => update('value', value))); fields.append(url, picker); if (block.type === 'image') { const alt = document.createElement('input'); alt.value = block.alt || ''; alt.placeholder = 'Alt text'; alt.setAttribute('aria-label', 'Image alt text'); alt.addEventListener('input', e => update('alt', e.target.value)); fields.append(alt); } body.append(fields); }
          else if (block.type === 'custom') { const fields = document.createElement('div'); fields.className = 'custom-fields'; const name = document.createElement('input'); name.value = block.name || 'CustomBlock'; name.placeholder = 'Component name'; name.setAttribute('aria-label', 'Custom component name'); name.addEventListener('input', e => update('name', e.target.value)); const args = document.createElement('input'); args.value = block.value; args.placeholder = 'Arguments, e.g. id: 123'; args.setAttribute('aria-label', 'Custom component arguments'); args.addEventListener('input', e => update('value', e.target.value)); fields.append(name, args); body.append(fields); }
          else { const toolbar = document.createElement('div'); toolbar.className = 'format-toolbar'; toolbar.setAttribute('aria-label', 'Text formatting'); toolbar.innerHTML = '<button type="button" data-format="bold" title="Bold"><strong>B</strong></button><button type="button" data-format="italic" title="Italic"><em>I</em></button><button type="button" data-format="underline" title="Underline"><u>U</u></button><button type="button" data-format="strike" title="Strikethrough"><del>S</del></button><button type="button" data-format="link" title="Add link">↗</button>'; const field = document.createElement('textarea'); field.value = block.value; field.placeholder = 'Write text… Select text, then choose a format'; field.setAttribute('aria-label', 'Text with Markdown formatting'); configureTextEditor(field); field.addEventListener('input', e => update('value', e.target.value)); body.append(toolbar, field); toolbar.querySelectorAll('[data-format]').forEach(button => button.addEventListener('click', () => formatSelectionForBlock(field, block, update, button.dataset.format))); }
        }
        function formatSelectionForBlock(field, block, update, format) { const start = field.selectionStart; const end = field.selectionEnd; if (start === end) return; const selected = field.value.slice(start, end); const wrappers = { bold: ['**', '**'], italic: ['*', '*'], underline: ['__', '__'], strike: ['~~', '~~'] }; let before; let after; if (format === 'link') { const url = window.prompt('Link URL', 'https://'); if (!url) return; before = '['; after = `](${url})`; } else { [before, after] = wrappers[format]; } const value = field.value.slice(0, start) + before + selected + after + field.value.slice(end); update('value', value); field.value = value; field.focus(); field.setSelectionRange(start + before.length, end + before.length); setStatus('Formatted'); }
        function render() {
          canvas.innerHTML = '';
          if (!state.blocks.length) { canvas.innerHTML = '<div class="empty"><strong>Your canvas is empty.</strong><br>Choose a component to get started.</div>'; return; }
          state.blocks.forEach((block, index) => {
            const item = document.createElement('article'); item.className = 'block'; item.draggable = true; item.dataset.id = block.id;
            item.innerHTML = `<div class="drag-controls"><span class="drag-handle" title="Drag to rearrange" aria-label="Drag to rearrange">⠿</span><button class="move-button" data-move="up" title="Move up" aria-label="Move up">↑</button><button class="move-button" data-move="down" title="Move down" aria-label="Move down">↓</button></div><div class="block-body"><label class="block-label">${block.type === 'heading' ? `Heading ${block.level}` : block.type}</label></div><button class="remove" title="Remove component" aria-label="Remove component">×</button>`;
            const body = item.querySelector('.block-body');
            if (block.type === 'newsletter' || block.type === 'contact-form') { renderEmbedControl(body, block, (key, value) => updateBlock(block.id, key, value)); body.querySelector('.block-label').textContent = block.type === 'newsletter' ? 'Newsletter campaign' : 'Contact form'; }
            else if (block.type === 'separator') { const rule = document.createElement('div'); rule.className = 'preview-content'; rule.innerHTML = '<hr>'; body.querySelector('.block-label').textContent = 'Separator'; body.append(rule); }
            else if (block.type === 'ul' || block.type === 'ol') { const toolbar = document.createElement('div'); toolbar.className = 'format-toolbar'; toolbar.setAttribute('aria-label', 'Text formatting'); toolbar.innerHTML = '<button type="button" data-format="bold" title="Bold"><strong>B</strong></button><button type="button" data-format="italic" title="Italic"><em>I</em></button><button type="button" data-format="underline" title="Underline"><u>U</u></button><button type="button" data-format="strike" title="Strikethrough"><del>S</del></button><button type="button" data-format="link" title="Add link">↗</button>'; const field = document.createElement('textarea'); field.className = 'list-editor'; field.value = block.value; field.placeholder = 'One list item per line…'; field.setAttribute('aria-label', `${block.type === 'ul' ? 'Unordered' : 'Ordered'} list items`); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.querySelector('.block-label').textContent = block.type === 'ul' ? 'Unordered list' : 'Ordered list'; body.append(toolbar, field); toolbar.querySelectorAll('[data-format]').forEach(button => button.addEventListener('click', () => formatSelection(field, block.id, button.dataset.format))); }
            else if (block.type === 'blockquote') { const fields = document.createElement('div'); fields.className = 'quote-fields'; const quote = document.createElement('textarea'); quote.value = block.value; quote.placeholder = 'Quote text…'; quote.setAttribute('aria-label', 'Blockquote text'); quote.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); const cite = document.createElement('input'); cite.value = block.cite || ''; cite.placeholder = 'Citation (optional)'; cite.setAttribute('aria-label', 'Blockquote citation'); cite.addEventListener('input', e => updateBlock(block.id, 'cite', e.target.value)); fields.append(quote, cite); body.querySelector('.block-label').textContent = 'Blockquote'; body.append(fields); }
            else if (block.type === 'heading') { const toolbar = document.createElement('div'); toolbar.className = 'heading-toolbar'; toolbar.setAttribute('aria-label', 'Heading level'); toolbar.innerHTML = [1,2,3,4,5,6].map(level => `<button type="button" class="${level === block.level ? 'active' : ''}" data-level="${level}" title="Heading ${level}">H${level}</button>`).join(''); toolbar.querySelectorAll('[data-level]').forEach(button => button.addEventListener('click', () => { updateBlock(block.id, 'level', Number(button.dataset.level)); render(); })); const field = document.createElement('input'); field.value = block.value; field.placeholder = 'Heading text…'; field.setAttribute('aria-label', 'Heading text'); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.querySelector('.block-label').after(toolbar, field); }
            else if (block.type === 'html') { const field = document.createElement('textarea'); field.className = 'html-editor'; field.value = block.value; field.placeholder = '<div>Raw HTML…</div>'; field.setAttribute('aria-label', 'Raw HTML'); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.querySelector('.block-label').textContent = 'Raw HTML'; body.append(field); }
            else if (block.type === 'code') { const language = document.createElement('input'); language.className = 'code-language'; language.value = block.language; language.placeholder = 'Language (e.g. swift)'; language.setAttribute('aria-label', 'Code language'); language.addEventListener('input', e => updateBlock(block.id, 'language', e.target.value)); const field = document.createElement('textarea'); field.className = 'code-editor'; field.value = block.value; field.placeholder = 'Paste or type code…'; field.setAttribute('aria-label', 'Code'); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.querySelector('.block-label').textContent = 'Code block'; body.append(language, field); }
            else if (block.type === 'grid') { const settings = block.settings || { desktop: 3, tablet: 2, mobile: 1 }; block.settings = settings; block.columns = block.columns || []; ensureGridColumns(block); const controls = document.createElement('div'); controls.className = 'grid-settings'; const responsive = document.createElement('div'); responsive.className = 'grid-responsive'; [['desktop', settings.desktop], ['tablet', settings.tablet], ['mobile', settings.mobile], ['cells', block.columnCount]].forEach(([size, value]) => { const label = document.createElement('label'); if (size === 'cells') label.className = 'cells-stepper'; label.textContent = size; const field = document.createElement('input'); field.type = 'number'; field.min = 1; field.max = 12; field.value = value; field.addEventListener('change', e => { const nextValue = Math.max(1, Math.min(12, Number(e.target.value) || 1)); if (size === 'cells') block.columnCount = nextValue; else block.settings[size] = nextValue; ensureGridColumns(block); syncRaw(); render(); }); label.append(field); responsive.append(label); }); const columns = document.createElement('div'); columns.className = 'grid-columns'; columns.style.setProperty('--grid-desktop', settings.desktop); columns.style.setProperty('--grid-tablet', settings.tablet); columns.style.setProperty('--grid-mobile', settings.mobile); for (let columnIndex = 0; columnIndex < block.columnCount; columnIndex++) { const column = document.createElement('div'); column.className = 'grid-column'; const label = document.createElement('label'); label.textContent = `Cell ${columnIndex + 1}`; column.append(label); (block.columns[columnIndex].blocks || []).forEach((child, childIndex) => { const childCard = document.createElement('article'); childCard.className = 'grid-child block'; childCard.draggable = true; childCard.innerHTML = '<div class="drag-controls"><span class="drag-handle" title="Drag to rearrange" aria-label="Drag to rearrange">⠿</span><button class="move-button" data-move="up" title="Move up" aria-label="Move up">↑</button><button class="move-button" data-move="down" title="Move down" aria-label="Move down">↓</button></div><div class="block-body"><label class="block-label">' + (child.type === 'heading' ? `Heading ${child.level}` : child.type) + '</label></div><button class="remove" title="Remove component" aria-label="Remove component">×</button>'; const childBody = childCard.querySelector('.block-body'); renderBlockContent(childBody, child, (key, value) => { child[key] = value; syncRaw(); setStatus('Updated'); }); childCard.querySelector('.remove').addEventListener('click', () => { block.columns[columnIndex].blocks.splice(childIndex, 1); syncRaw(); render(); setStatus('Removed'); }); childCard.querySelectorAll('[data-move]').forEach(button => button.addEventListener('click', () => { const target = button.dataset.move === 'up' ? childIndex - 1 : childIndex + 1; if (target < 0 || target >= block.columns[columnIndex].blocks.length) return; [block.columns[columnIndex].blocks[childIndex], block.columns[columnIndex].blocks[target]] = [block.columns[columnIndex].blocks[target], block.columns[columnIndex].blocks[childIndex]]; syncRaw(); render(); setStatus('Rearranged'); })); childCard.addEventListener('dragstart', e => { e.stopPropagation(); e.dataTransfer.effectAllowed = 'move'; state.dragging = { kind: 'grid-child', gridId: block.id, columnIndex, childIndex }; childCard.classList.add('dragging'); }); childCard.addEventListener('dragend', e => { e.stopPropagation(); clearDragState(); }); childCard.addEventListener('dragover', e => { e.preventDefault(); e.stopPropagation(); marker.classList.remove('visible'); marker.dataset.position = ''; canvas.classList.remove('drag-over'); if (state.dragging && ['existing', 'grid-child'].includes(state.dragging.kind)) childCard.classList.add('drop-target'); }); childCard.addEventListener('drop', e => { e.preventDefault(); e.stopPropagation(); if (!state.dragging || !['existing', 'grid-child'].includes(state.dragging.kind)) return; const drag = state.dragging; const sameColumn = drag.kind === 'grid-child' && drag.gridId === block.id && drag.columnIndex === columnIndex; const from = sameColumn ? drag.childIndex : -1; const moved = takeDraggedBlock(drag); if (!moved) return; const to = Math.min(Math.max(0, childIndex - (sameColumn && from < childIndex ? 1 : 0)), block.columns[columnIndex].blocks.length); block.columns[columnIndex].blocks.splice(to, 0, moved.block); clearDragState(); syncRaw(); render(); setStatus('Moved into grid'); }); column.append(childCard); }); if (!block.columns[columnIndex].blocks.length) { const empty = document.createElement('div'); empty.className = 'grid-column-empty'; empty.textContent = 'Drag a component here'; column.append(empty); } column.addEventListener('dragover', e => { e.preventDefault(); e.stopPropagation(); marker.classList.remove('visible'); marker.dataset.position = ''; canvas.classList.remove('drag-over'); if (state.dragging && ['new', 'existing', 'grid-child'].includes(state.dragging.kind)) column.classList.add('drop-target'); }); column.addEventListener('dragleave', () => column.classList.remove('drop-target')); column.addEventListener('drop', e => { e.preventDefault(); e.stopPropagation(); if (!state.dragging || !['new', 'existing', 'grid-child'].includes(state.dragging.kind)) return; const drag = state.dragging; const moved = drag.kind === 'new' ? { block: createBlock(drag.type) } : takeDraggedBlock(drag); if (!moved) return; block.columns[columnIndex].blocks.push(moved.block); clearDragState(); syncRaw(); render(); setStatus(drag.kind === 'new' ? 'Added to grid' : 'Moved into grid'); }); columns.append(column); } controls.append(responsive, columns); body.querySelector('.block-label').textContent = 'Grid'; body.append(controls); }
            else if (block.type === 'image' || block.type === 'video') { const fields = document.createElement('div'); fields.className = 'media-fields'; const url = document.createElement('input'); url.value = block.value; url.placeholder = block.type === 'image' ? 'Image URL' : 'Video URL'; url.setAttribute('aria-label', `${block.type} URL`); url.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); const picker = document.createElement('button'); picker.type = 'button'; picker.className = 'media-picker-button'; picker.textContent = 'Choose from gallery'; picker.addEventListener('click', () => openMediaPicker(block.type, value => updateBlock(block.id, 'value', value))); fields.append(url, picker); if (block.type === 'image') { const alt = document.createElement('input'); alt.value = block.alt || ''; alt.placeholder = 'Alt text'; alt.setAttribute('aria-label', 'Image alt text'); alt.addEventListener('input', e => updateBlock(block.id, 'alt', e.target.value)); fields.append(alt); } body.querySelector('.block-label').textContent = block.type === 'image' ? 'Image' : 'Video'; body.append(fields); }
            else if (block.type === 'custom') { const fields = document.createElement('div'); fields.className = 'custom-fields'; const name = document.createElement('input'); name.value = block.name || 'CustomBlock'; name.placeholder = 'Component name'; name.setAttribute('aria-label', 'Custom component name'); name.addEventListener('input', e => updateBlock(block.id, 'name', e.target.value)); const args = document.createElement('input'); args.value = block.value; args.placeholder = 'Arguments, e.g. id: 123'; args.setAttribute('aria-label', 'Custom component arguments'); args.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); fields.append(name, args); body.querySelector('.block-label').textContent = 'Custom block'; body.append(fields); }
            else { const toolbar = document.createElement('div'); toolbar.className = 'format-toolbar'; toolbar.setAttribute('aria-label', 'Text formatting'); toolbar.innerHTML = '<button type="button" data-format="bold" title="Bold"><strong>B</strong></button><button type="button" data-format="italic" title="Italic"><em>I</em></button><button type="button" data-format="underline" title="Underline"><u>U</u></button><button type="button" data-format="strike" title="Strikethrough"><del>S</del></button><button type="button" data-format="link" title="Add link">↗</button>'; const field = document.createElement('textarea'); field.value = block.value; field.placeholder = 'Write text… Select text, then choose a format'; field.setAttribute('aria-label', 'Text with Markdown formatting'); configureTextEditor(field); field.addEventListener('input', e => updateBlock(block.id, 'value', e.target.value)); body.append(toolbar, field); toolbar.querySelectorAll('[data-format]').forEach(button => button.addEventListener('click', () => formatSelection(field, block.id, button.dataset.format))); }
            item.querySelector(':scope > .remove').addEventListener('click', e => { e.stopPropagation(); state.blocks.splice(index, 1); syncRaw(); render(); setStatus('Removed'); });
            item.querySelector('.drag-controls').querySelectorAll('[data-move]').forEach(button => button.addEventListener('click', e => { e.stopPropagation(); const target = button.dataset.move === 'up' ? index - 1 : index + 1; if (target < 0 || target >= state.blocks.length) return; [state.blocks[index], state.blocks[target]] = [state.blocks[target], state.blocks[index]]; syncRaw(); render(); setStatus('Rearranged'); }));
            item.addEventListener('dragstart', () => { state.dragging = { kind: 'existing', id: block.id }; item.classList.add('dragging'); }); item.addEventListener('dragend', clearDragState);
            item.addEventListener('dragover', e => { e.preventDefault(); if (!state.dragging || (state.dragging.kind === 'existing' && state.dragging.id === block.id)) return; const after = e.clientY > item.getBoundingClientRect().top + item.offsetHeight / 2; placeMarker(item, after); canvas.classList.add('drag-over'); });
            item.addEventListener('drop', e => { e.preventDefault(); if (!state.dragging) return; const drag = state.dragging; const after = e.clientY > item.getBoundingClientRect().top + item.offsetHeight / 2; let to = state.blocks.findIndex(b => b.id === block.id) + (after ? 1 : 0); if (drag.kind === 'new') { state.blocks.splice(to, 0, createBlock(drag.type)); setStatus('Added'); } else if (drag.kind === 'existing' || drag.kind === 'grid-child') { const moved = takeDraggedBlock(drag); if (!moved) return; if (drag.kind === 'existing' && moved.index < to) to--; state.blocks.splice(to, 0, moved.block); setStatus(drag.kind === 'grid-child' ? 'Moved out of grid' : 'Rearranged'); } syncRaw(); clearDragState(); render(); });
            canvas.append(item);
          });
        }
        function createBlock(type) { if (type === 'grid') return makeGridBlock(); const block = newBlock(type, ''); if (type === 'code') block.language = ''; if (type === 'image') block.alt = ''; if (type === 'blockquote') block.cite = ''; if (type === 'custom') block.name = ''; return block; }
        function takeDraggedBlock(drag) { if (drag.kind === 'existing') { const index = state.blocks.findIndex(block => block.id === drag.id); return index < 0 ? null : { block: state.blocks.splice(index, 1)[0], index }; } if (drag.kind === 'grid-child') { const grid = state.blocks.find(block => block.id === drag.gridId); if (!grid || !grid.columns[drag.columnIndex]) return null; const column = grid.columns[drag.columnIndex].blocks; return drag.childIndex < 0 ? null : { block: column.splice(drag.childIndex, 1)[0], index: -1 }; } return null; }
        function placeMarker(item, after) { const position = `${item.dataset.id}:${after ? 'after' : 'before'}`; if (marker.dataset.position !== position) { if (after) item.after(marker); else item.before(marker); marker.dataset.position = position; } marker.classList.add('visible'); }
        function clearDragState() { state.dragging = null; marker.classList.remove('visible'); marker.dataset.position = ''; canvas.classList.remove('drag-over'); document.querySelectorAll('.component-button').forEach(button => button.classList.remove('dragging')); document.querySelectorAll('.grid-column, .grid-child').forEach(element => element.classList.remove('drop-target', 'dragging')); }
        canvas.addEventListener('dragover', e => { e.preventDefault(); if (!state.dragging || e.target.closest('.block') || marker.classList.contains('visible')) return; canvas.append(marker); marker.dataset.position = 'canvas-end'; marker.classList.add('visible'); canvas.classList.add('drag-over'); });
        canvas.addEventListener('drop', e => { e.preventDefault(); if (!state.dragging || e.target.closest('.block')) return; const drag = state.dragging; let to = state.blocks.length; const position = marker.dataset.position; const targetMatch = position && position.match(/^([^:]+):(before|after)$/); if (targetMatch) { to = state.blocks.findIndex(block => block.id === targetMatch[1]) + (targetMatch[2] === 'after' ? 1 : 0); } if (drag.kind === 'existing') { const from = state.blocks.findIndex(b => b.id === drag.id); if (from >= 0) { const [moved] = state.blocks.splice(from, 1); if (from < to) to--; state.blocks.splice(to, 0, moved); } } else if (drag.kind === 'new') state.blocks.splice(to, 0, createBlock(drag.type)); syncRaw(); clearDragState(); render(); setStatus(drag.kind === 'new' ? 'Added' : 'Rearranged'); });
        function showMode(mode) { state.mode = mode; document.querySelector('#visualView').hidden = mode !== 'visual'; document.querySelector('#previewView').hidden = mode !== 'preview'; document.querySelector('#rawView').hidden = mode !== 'raw'; document.querySelectorAll('[data-mode]').forEach(button => button.classList.toggle('active', button.dataset.mode === mode)); if (mode === 'raw') syncRaw(); if (mode === 'preview') renderPreview(); }
        document.querySelectorAll('[data-mode]').forEach(button => button.addEventListener('click', () => { if (state.mode === 'raw' && button.dataset.mode !== 'raw') { state.blocks = parseMarkdown(input.value); render(); } showMode(button.dataset.mode); }));
        function formatSelection(field, id, format) { const start = field.selectionStart; const end = field.selectionEnd; if (start === end) return; const selected = field.value.slice(start, end); const wrappers = { bold: ['**', '**'], italic: ['*', '*'], underline: ['__', '__'], strike: ['~~', '~~'] }; let before; let after; if (format === 'link') { const url = window.prompt('Link URL', 'https://'); if (!url) return; before = '['; after = `](${url})`; } else { [before, after] = wrappers[format]; } const value = field.value.slice(0, start) + before + selected + after + field.value.slice(end); updateBlock(id, 'value', value); field.value = value; field.focus(); field.setSelectionRange(start + before.length, end + before.length); setStatus('Formatted'); }
        document.querySelectorAll('.component-button').forEach(button => { const description = button.querySelector('small'); if (description) button.title = description.textContent; });
        document.querySelectorAll('[data-insert]').forEach(button => button.addEventListener('click', () => { state.insertPosition = button.dataset.insert; document.querySelectorAll('[data-insert]').forEach(option => option.classList.toggle('active', option === button)); }));
        document.querySelectorAll('[data-add]').forEach(button => { button.draggable = true; button.addEventListener('click', () => { const block = createBlock(button.dataset.add); if (state.insertPosition === 'top') state.blocks.unshift(block); else state.blocks.push(block); syncRaw(); render(); setStatus('Added'); }); button.addEventListener('dragstart', e => { e.dataTransfer.effectAllowed = 'copy'; e.dataTransfer.setData('text/plain', button.dataset.add); state.dragging = { kind: 'new', type: button.dataset.add }; button.classList.add('dragging'); canvas.classList.add('drag-over'); }); button.addEventListener('dragend', clearDragState); });
        input.value = initialMarkdown; state.blocks = parseMarkdown(initialMarkdown); render();

    }
    """#

    public func rules() -> [any CSS.Rule] {
        let root = ".new-admin-rich-content-editor"

        let baseSelectors: [any CSS.Selector] = [
            Custom("\(root)") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
                Width(100.percent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) > .new-admin-media-picker > label") {
                Display(.none)
            },
            Custom(
                "\(root) > .new-admin-media-picker > [data-media-picker-open]"
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
                Gap(6.px)
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
            Custom("\(root) .sidebar-footer") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(16.px)
                BorderTop(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                Margin(top: 14.px)
                Padding(top: 10.px)
            },
            Custom("\(root) .hint") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.78.rem)
            },
            Custom("\(root) .insert-toggle") {
                Display(.flex)
                AlignItems(.center)
                Gap(9.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.78.rem)
            },
            Custom("\(root) .insert-toggle strong") {
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) .insert-options") {
                Display(.flex)
            },
            Custom("\(root) .insert-options button") {
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Padding(vertical: 5.px, horizontal: 9.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Cursor(.pointer)
            },
            Custom("\(root) .insert-options button.active") {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Link.default))
                FontWeight(.number(700))
            },
            Custom("\(root) .editor-bar") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(12.px)
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                Padding(vertical: 13.px, horizontal: 18.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.82.rem)
            },
            Custom("\(root) .mode-switch") {
                Display(.flex)
                Gap(3.px)
                Padding(3.px)
                BorderRadius(8.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom("\(root) .mode-switch button") {
                Border(0)
                BorderRadius(6.px)
                Padding(vertical: 5.px, horizontal: 10.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.75.rem)
                Cursor(.pointer)
            },
            Custom("\(root) .mode-switch button.active") {
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) .status") {
                Color(.variable(TokenKey.Colors.Link.default))
                FontWeight(.number(600))
            },
            Custom("\(root) .visual-canvas") {
                MinHeight(560.px)
                Padding(13.px)
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
                    .tracks([.length(25.px), .fraction(1.fr), .auto])
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
            Custom("\(root) .move-button, \(root) .remove") {
                Border(0)
                BorderRadius(6.px)
                Padding(3.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Cursor(.pointer)
            },
            Custom("\(root) .move-button:hover, \(root) .remove:hover") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
                Color(.variable(TokenKey.Colors.Link.default))
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
                Padding(18.px)
            },
            Custom("\(root) #markdownInput") {
                Display(.block)
                Width(100.percent)
                UnsafeRawProperty(name: "min-height", value: "12lh")
                Resize(.none)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Padding(17.px)
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
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
                Padding(vertical: 42.px, horizontal: 7.percent)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            },
            Custom("\(root) .preview-content") {
                MaxWidth(760.px)
                MarginLeft(.auto)
                MarginRight(.auto)
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
                "\(root) .preview-content img, \(root) .preview-content video"
            ) {
                Display(.block)
                MaxWidth(100.percent)
                Margin(top: 8.px, bottom: 22.px)
                BorderRadius(9.px)
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
            Custom("\(root) .embed-fields") {
                Margin(bottom: 8.px)
            },
            Custom("\(root) .grid-columns") {
                Display(.grid)
                GridTemplateColumns(.repeat(3, .fraction(1.fr)))
                Gap(8.px)
            },
            Custom("\(root) .grid-column, \(root) .grid-child") {
                MinWidth(0.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Padding(8.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom(
                "\(root) .grid-column.drop-target, \(root) .grid-child.drop-target"
            ) {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom("\(root) .grid-column-empty") {
                MinHeight(82.px)
                Display(.grid)
                AlignItems(.center)
                JustifyContent(.center)
                Border(
                    1.px,
                    .dashed,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(6.px)
                Padding(10.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                TextAlign(.center)
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
            Custom("\(root) .mce-embed-picker") {
                Position(.fixed)
                Top(0.px)
                Right(0.px)
                Bottom(0.px)
                Left(0.px)
                ZIndex(.number(20))
                Display(.none)
                AlignItems(.center)
                JustifyContent(.center)
                Padding(24.px)
                Background(.transparent)
            },
            Custom("\(root) .mce-embed-picker::before") {
                Content(.string("\"\""))
                Position(.absolute)
                UnsafeRawProperty(name: "inset", value: "0")
                Background(
                    .variable(TokenKey.Colors.Materials.Primary.tint)
                )
                Opacity(0.75)
            },
            Custom("\(root) .mce-embed-picker.is-visible") {
                Display(.flex)
            },
            Custom("\(root) .mce-embed-picker-dialog") {
                Position(.relative)
                ZIndex(.number(1))
                Width(90.percent)
                MaxWidth(720.px)
                MaxHeight(90.vh)
                Overflow(.auto)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(12.px)
                Padding(18.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
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
                Margin(bottom: 14.px)
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
            context.build(NewAdminFormFieldLabel(text: state.label))
            Div {
                Div {
                    P("Add component").class("eyebrow")
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
                    Div {
                        P(
                            "Drag the handle to rearrange blocks. Select text inside a text block to format it."
                        )
                        .class("hint")
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
                    .class("sidebar-footer")
                }
                .class("panel", "sidebar")
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
                        Span("Ready").id("status").class("status")
                    }
                    .class("editor-bar")
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
                            .rows(12)
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
                "new-admin-rich-content-editor"
            )
            .data("markdown-image-picker", "markdown-image-url")
            .data("markdown-video-picker", "markdown-video-url")
            .data(
                "markdown-media-base-url",
                "/media/"
            )
            context.build(
                NewAdminFormFieldMediaPicker(
                    state: .init(
                        field: .init(
                            key: "markdown-image-url",
                            label: "Choose image",
                            value: nil,
                            error: nil
                        ),
                        selectedAsset: nil,
                        browsePath:
                            "/admin/media/assets/?picker=1&field=markdown-image-url&extensions=png,jpg,jpeg,webp,gif",
                        allowedExtensions: [
                            "png", "jpg", "jpeg", "webp", "gif",
                        ],
                        outputMode: .relativeURL,
                        showsCurrentCard: false
                    )
                )
            )
            context.build(
                NewAdminFormFieldMediaPicker(
                    state: .init(
                        field: .init(
                            key: "markdown-video-url",
                            label: "Choose video",
                            value: nil,
                            error: nil
                        ),
                        selectedAsset: nil,
                        browsePath:
                            "/admin/media/assets/?picker=1&field=markdown-video-url&extensions=mp4,mov,webm",
                        allowedExtensions: ["mp4", "mov", "webm"],
                        outputMode: .relativeURL,
                        showsCurrentCard: false
                    )
                )
            )
            if let error = state.error {
                Span(error).class("field-error")
            }
            Script(Self.markdownEditorScript)
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-rich-content-editor")
    }
}
