<!-- refreshed: 2026-06-19; verified against alicentra/SillyTavern release branch -->
# External Integrations

**Analysis Date:** 2026-06-18
**Verified Against:** `alicentra/SillyTavern` `release` branch (checked 2026-06-19)

## APIs & External Services

**LLM Providers (Chat/Text Completion):**
- OpenAI - `src/endpoints/openai.js`, Key: `api_key_openai`
- Anthropic/Claude - `src/endpoints/anthropic.js`, Key: `api_key_claude`
- Google MakerSuite/Gemini - `src/endpoints/google.js`, Key: `api_key_makersuite`
- Google Vertex AI - Key: `api_key_vertexai`
- Azure OpenAI - `src/endpoints/azure.js`, Key: `api_key_azure_openai`
- OpenRouter - `src/endpoints/openrouter.js`, Key: `api_key_openrouter`
- NovelAI - `src/endpoints/novelai.js`, Key: `api_key_novel`
- AI Horde - `src/endpoints/horde.js`, SDK: `@zeldafan0225/ai_horde`, Key: `api_key_horde`
- DeepSeek - Key: `api_key_deepseek`
- Mistral AI - Key: `api_key_mistralai`
- Groq - Key: `api_key_groq`
- Cohere - Key: `api_key_cohere`
- Perplexity - Key: `api_key_perplexity`
- Together AI - Key: `api_key_togetherai`
- Fireworks - Key: `api_key_fireworks`
- xAI - Key: `api_key_xai`
- MiniMax - `src/endpoints/minimax.js`, Key: `api_key_minimax`
- NanoGPT - `src/endpoints/nanogpt.js`, Key: `api_key_nanogpt`
- Featherless - Key: `api_key_featherless`
- Mancer - Key: `api_key_mancer`
- InfermaticAI - Key: `api_key_infermaticai`
- DreamGen - Key: `api_key_dreamgen`
- AI21 - Key: `api_key_ai21`
- Moonshot - Key: `api_key_moonshot`
- SiliconFlow - Key: `api_key_siliconflow`
- Chutes - Key: `api_key_chutes`
- ElectronHub - Key: `api_key_electronhub`
- AIML API - Key: `api_key_aimlapi`

**Local LLM Backends:**
- KoboldAI/KoboldCpp - `src/endpoints/backends/kobold.js`, Key: `api_key_koboldcpp`
- Text Generation WebUI (Ooba) - Key: `api_key_ooba`
- llama.cpp - Key: `api_key_llamacpp`
- Aphrodite - Key: `api_key_aphrodite`
- TabbyAPI - Key: `api_key_tabby`
- vLLM - Key: `api_key_vllm`

**Image Generation:**
- Stable Diffusion (local/remote) - `src/endpoints/stable-diffusion.js`
- Stability AI - Key: `api_key_stability`
- ComfyUI (RunPod) - Key: `api_key_comfy_runpod`
- Black Forest Labs (BFL) - Key: `api_key_bfl`
- Fal.ai - Key: `api_key_falai`
- Pollinations - Key: `api_key_pollinations`

**Speech/TTS:**
- ElevenLabs - Key: `api_key_elevenlabs`
- Azure TTS - Key: `api_key_azure_tts`
- Custom OpenAI-compatible TTS - Key: `api_key_custom_openai_tts`
- Speech endpoint: `src/endpoints/speech.js`

**Image Captioning:**
- Caption endpoint: `src/endpoints/caption.js`

**Translation:**
- DeepL - Key: `deepl`
- DeepLX (self-hosted) - Key: `deeplx_url`
- LibreTranslate - Key: `libre`, URL: `libre_url`
- Lingva - URL: `lingva_url`
- OneRing Translator - URL: `oneringtranslator_url`
- Google Translate - via `google-translate-api-x` (no key)
- Bing Translate - via `bing-translate-api` (no key)
- Endpoint: `src/endpoints/translate.js`

**Search/Retrieval:**
- SerpAPI - Key: `api_key_serpapi`
- Tavily - Key: `api_key_tavily`
- Serper - Key: `api_key_serper`

**Embeddings:**
- NomicAI - Key: `api_key_nomicai`
- HuggingFace - Key: `api_key_huggingface`
- Vector storage: `src/vectors/` using `vectra`

**Classification:**
- Sentiment/content classification: `src/endpoints/classify.js`
- Uses `sillytavern-transformers` locally

## Data Storage

**Databases:**
- None (no SQL/NoSQL database)
- File-based storage using JSON files and `node-persist`
- Vector embeddings via `vectra` (local file-based vector DB)

**File Storage:**
- Local filesystem only
- User data in configurable `DATA_ROOT` directory
- Chat logs as JSON/JSONL files
- Character cards as PNG with embedded metadata

**Caching:**
- None (no Redis/Memcached)

## Authentication & Identity

**Auth Provider:**
- Custom multi-user system (`src/users.js`)
- Cookie-session based auth (`cookie-session`)
- Password recovery: `src/recover-password.js`
- Admin endpoints: `src/endpoints/users-admin.js`
- No external OAuth/SSO integration detected

## Monitoring & Observability

**Error Tracking:**
- None (console logging only)

**Logs:**
- Console output with `chalk` for color
- Response time tracking via `response-time` middleware

## CI/CD & Deployment

**Hosting:**
- Self-hosted (bare metal, Docker, or Google Colab)
- Docker configs in `docker/`
- Colab notebook support in `colab/`

**CI Pipeline:**
- GitHub Actions workflows are present in `.github/workflows/`
- Notable workflows: `docker-publish.yml`, `npm-publish.yml`, `pr-checks.yml`, `pr-check-merge-conflicts.yaml`, issue/PR automation workflows

## Environment Configuration

**Required env vars:**
- None strictly required (config.yaml based)

**Secrets location:**
- `secrets.json` in user data directory (managed via `src/endpoints/secrets.js`)
- Per-user secret storage for multi-user setups

## Webhooks & Callbacks

**Incoming:**
- None detected

**Outgoing:**
- None detected

## Plugin System

- Plugin loader: `src/plugin-loader.js`
- Plugins directory: `plugins/`
- Install/update via `npm run plugins:install` / `npm run plugins:update`

---

*Integration audit: 2026-06-18*
