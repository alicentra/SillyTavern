import { eventSource, event_types, scrollChatToBottom } from '../../../script.js';

const BOTTOM_TOLERANCE = 10;

let shouldAutoScroll = true;

function getChatElement() {
    const chatElement = document.getElementById('chat');
    return chatElement instanceof HTMLElement ? chatElement : null;
}

function isChatAtBottom(chatElement) {
    return Math.abs(chatElement.scrollHeight - chatElement.clientHeight - chatElement.scrollTop) <= BOTTOM_TOLERANCE;
}

function updateAutoScrollState() {
    const chatElement = getChatElement();

    if (!chatElement) {
        return;
    }

    shouldAutoScroll = isChatAtBottom(chatElement);
}

function scrollGeneratedTextIntoView() {
    if (!shouldAutoScroll) {
        return;
    }

    scrollChatToBottom({ waitForFrame: true });
}

jQuery(() => {
    const chatElement = getChatElement();

    if (!chatElement) {
        return;
    }

    updateAutoScrollState();
    chatElement.addEventListener('scroll', updateAutoScrollState, { passive: true });

    eventSource.on(event_types.CHAT_CHANGED, () => {
        requestAnimationFrame(updateAutoScrollState);
    });

    eventSource.makeLast(event_types.STREAM_TOKEN_RECEIVED, scrollGeneratedTextIntoView);
    eventSource.makeLast(event_types.CHARACTER_MESSAGE_RENDERED, scrollGeneratedTextIntoView);
    eventSource.makeLast(event_types.TOOL_CALLS_RENDERED, scrollGeneratedTextIntoView);
    eventSource.on(event_types.GENERATION_ENDED, () => {
        if (!shouldAutoScroll) {
            return;
        }

        scrollChatToBottom({ waitForFrame: true });
        requestAnimationFrame(() => scrollChatToBottom({ waitForFrame: true }));
    });
});