const allowedTypes = ["info", "success", "warning", "alert"];
const allowedPositions = ["top-right", "top-left", "bottom-right", "bottom-left"];

const defaultOptions = {
  type: "info",
  title: "",
  message: "",
  duration: 4500,
  dismissible: true,
  persistent: false,
  position: "top-right",
  key: "",
};

const config = {
  maxVisible: 5,
};

const state = {
  counter: 0,
  toasts: new Map(),
  keys: new Map(),
  stacks: new Map(),
};

for (const position of allowedPositions) {
  state.stacks.set(position, {
    root: null,
    visible: [],
    queue: [],
  });
}

function normalizeType(type) {
  return allowedTypes.includes(type) ? type : defaultOptions.type;
}

function normalizePosition(position) {
  return allowedPositions.includes(position) ? position : defaultOptions.position;
}

function normalizeDuration(duration, persistent) {
  if (persistent) {
    return 0;
  }

  const value = Number(duration);
  return Number.isFinite(value) && value > 0 ? value : 0;
}

function getStack(position) {
  return state.stacks.get(normalizePosition(position));
}

function getToastRoot(position) {
  const stack = getStack(position);
  if (stack.root) {
    return stack.root;
  }

  const root = document.createElement("div");
  root.className = `toast-root toast-root--${normalizePosition(position)}`;
  root.dataset.position = normalizePosition(position);
  document.body.prepend(root);
  stack.root = root;
  return root;
}

function createProgressElement() {
  const track = document.createElement("div");
  track.className = "toast__progress";
  track.setAttribute("aria-hidden", "true");

  const bar = document.createElement("div");
  bar.className = "toast__progress-bar";
  track.append(bar);
  return track;
}

function createToastElement(item) {
  const type = normalizeType(item.type);
  const role = type === "warning" || type === "alert" ? "alert" : "status";
  const ariaLive = type === "warning" || type === "alert" ? "assertive" : "polite";

  const toast = document.createElement("div");
  toast.className = `toast toast--${type}`;
  toast.id = item.id;
  toast.setAttribute("role", role);
  toast.setAttribute("aria-live", ariaLive);
  toast.setAttribute("aria-atomic", "true");

  const marker = document.createElement("div");
  marker.className = "toast__marker";
  marker.setAttribute("aria-hidden", "true");

  const content = document.createElement("div");
  content.className = "toast__content";

  const title = document.createElement("div");
  title.className = "toast__title";

  const message = document.createElement("div");
  message.className = "toast__message";

  const close = document.createElement("button");
  close.className = "toast__close";
  close.type = "button";
  close.setAttribute("aria-label", "Dismiss notification");
  close.textContent = "×";
  close.addEventListener("click", () => dismiss(item.id));

  const progress = createProgressElement();

  content.append(title, message);
  toast.append(marker, content, close, progress);

  toast.addEventListener("mouseenter", () => pause(item.id));
  toast.addEventListener("mouseleave", () => resume(item.id));
  toast.addEventListener("focusin", () => pause(item.id));
  toast.addEventListener("focusout", () => resume(item.id));

  item.element = toast;
  item.titleElement = title;
  item.messageElement = message;
  item.closeElement = close;
  item.progressElement = progress;
  item.progressBarElement = progress.querySelector(".toast__progress-bar");

  applyToastContent(item);
  return toast;
}

function applyToastContent(item) {
  item.type = normalizeType(item.type);
  item.element.className = `toast toast--${item.type}`;
  item.element.setAttribute(
    "role",
    item.type === "warning" || item.type === "alert" ? "alert" : "status"
  );
  item.element.setAttribute(
    "aria-live",
    item.type === "warning" || item.type === "alert" ? "assertive" : "polite"
  );

  item.titleElement.textContent = item.title;
  item.titleElement.hidden = !item.title;
  item.messageElement.textContent = item.message;
  item.messageElement.hidden = !item.message;
  item.closeElement.hidden = !item.dismissible;
  item.progressElement.hidden = item.persistent || item.duration <= 0;
}

function createToastItem(options) {
  const id = options.id || `toast-${Date.now()}-${state.counter += 1}`;
  const persistent = Boolean(options.persistent);
  const duration = normalizeDuration(options.duration, persistent);

  return {
    ...defaultOptions,
    ...options,
    id,
    type: normalizeType(options.type),
    position: normalizePosition(options.position),
    duration,
    persistent,
    element: null,
    timer: null,
    startedAt: 0,
    remaining: duration,
    paused: false,
    leaving: false,
    removed: false,
  };
}

function startTimer(item) {
  window.clearTimeout(item.timer);

  if (item.persistent || item.duration <= 0) {
    return;
  }

  item.startedAt = performance.now();
  item.progressBarElement.style.transition = "none";
  item.progressBarElement.style.transform = `scaleX(${item.remaining / item.duration})`;

  requestAnimationFrame(() => {
    item.progressBarElement.style.transition = `transform ${item.remaining}ms linear`;
    item.progressBarElement.style.transform = "scaleX(0)";
  });

  item.timer = window.setTimeout(() => dismiss(item.id), item.remaining);
}

function pause(id) {
  const item = state.toasts.get(id);
  if (!item || item.paused || item.persistent || item.duration <= 0) {
    return;
  }

  item.paused = true;
  window.clearTimeout(item.timer);
  item.remaining = Math.max(
    0,
    item.remaining - (performance.now() - item.startedAt)
  );

  const progress = item.remaining / item.duration;
  item.progressBarElement.style.transition = "none";
  item.progressBarElement.style.transform = `scaleX(${progress})`;
}

function resume(id) {
  const item = state.toasts.get(id);
  if (!item || !item.paused || item.persistent || item.duration <= 0) {
    return;
  }

  item.paused = false;
  startTimer(item);
}

function showQueued(position) {
  const stack = getStack(position);

  while (stack.visible.length < config.maxVisible && stack.queue.length > 0) {
    const item = stack.queue.shift();
    mount(item);
  }
}

function mount(item) {
  const stack = getStack(item.position);
  const root = getToastRoot(item.position);
  const element = createToastElement(item);

  root.append(element);
  stack.visible.push(item.id);
  state.toasts.set(item.id, item);

  if (item.key) {
    state.keys.set(item.key, item.id);
  }

  startTimer(item);
}

function enqueue(item) {
  const stack = getStack(item.position);

  if (stack.visible.length >= config.maxVisible) {
    stack.queue.push(item);
    state.toasts.set(item.id, item);
    if (item.key) {
      state.keys.set(item.key, item.id);
    }
    return;
  }

  mount(item);
}

function removeFromCollections(item) {
  const stack = getStack(item.position);
  stack.visible = stack.visible.filter((id) => id !== item.id);
  stack.queue = stack.queue.filter((queued) => queued.id !== item.id);
  state.toasts.delete(item.id);

  if (item.key && state.keys.get(item.key) === item.id) {
    state.keys.delete(item.key);
  }

  showQueued(item.position);
}

function dismiss(id) {
  const item = state.toasts.get(id);
  if (!item || item.leaving) {
    return;
  }

  window.clearTimeout(item.timer);

  if (!item.element) {
    removeFromCollections(item);
    return;
  }

  item.leaving = true;
  item.element.classList.add("toast--leaving");

  const remove = () => {
    if (item.removed) {
      return;
    }

    item.removed = true;
    item.element.remove();
    removeFromCollections(item);
  };

  item.element.addEventListener("animationend", remove, { once: true });
  window.setTimeout(remove, 220);

  if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    remove();
  }
}

function show(options = {}) {
  if (options.key && state.keys.has(options.key)) {
    const id = state.keys.get(options.key);
    update(id, options);
    return id;
  }

  const item = createToastItem(options);
  enqueue(item);
  return item.id;
}

function update(id, options = {}) {
  const item = state.toasts.get(id);
  if (!item) {
    return null;
  }

  const oldPosition = item.position;
  const oldKey = item.key;
  const nextPersistent =
    options.persistent !== undefined ? Boolean(options.persistent) : item.persistent;

  Object.assign(item, options, {
    type: normalizeType(options.type || item.type),
    position: normalizePosition(options.position || item.position),
    persistent: nextPersistent,
    duration: normalizeDuration(
      options.duration !== undefined ? options.duration : item.duration,
      nextPersistent
    ),
  });

  item.remaining = item.duration;
  window.clearTimeout(item.timer);

  if (oldKey && oldKey !== item.key && state.keys.get(oldKey) === item.id) {
    state.keys.delete(oldKey);
  }

  if (item.key) {
    state.keys.set(item.key, item.id);
  }

  if (item.element) {
    applyToastContent(item);

    if (oldPosition !== item.position) {
      getStack(oldPosition).visible = getStack(oldPosition).visible.filter(
        (visibleId) => visibleId !== item.id
      );
      getToastRoot(item.position).append(item.element);
      getStack(item.position).visible.push(item.id);
      showQueued(oldPosition);
    }

    startTimer(item);
  } else if (oldPosition !== item.position) {
    getStack(oldPosition).queue = getStack(oldPosition).queue.filter(
      (queued) => queued.id !== item.id
    );
    getStack(item.position).queue.push(item);
    showQueued(oldPosition);
    showQueued(item.position);
  }

  return item.id;
}

function clear(filters = {}) {
  const entries = Array.from(state.toasts.values());

  for (const item of entries) {
    if (filters.position && item.position !== filters.position) {
      continue;
    }

    if (filters.type && item.type !== filters.type) {
      continue;
    }

    dismiss(item.id);
  }
}

function configure(options = {}) {
  if (Number.isInteger(options.maxVisible) && options.maxVisible > 0) {
    config.maxVisible = options.maxVisible;
    for (const position of allowedPositions) {
      showQueued(position);
    }
  }
}

window.toast = {
  show,
  update,
  dismiss,
  clear,
  configure,
  info(title, message, options = {}) {
    return show({ ...options, type: "info", title, message });
  },
  success(title, message, options = {}) {
    return show({ ...options, type: "success", title, message });
  },
  warning(title, message, options = {}) {
    return show({ ...options, type: "warning", title, message });
  },
  alert(title, message, options = {}) {
    return show({ ...options, type: "alert", title, message });
  },
};
