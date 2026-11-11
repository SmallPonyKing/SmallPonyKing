# Research behind the motion

The per-brand diagrams are original illustrative animations. They describe capabilities in broad terms, rather than simulating actual model internals or showing benchmark results. The recognizable brand artwork is preserved, with small positional motion and separate animated diagrams around it.

| Brand | Research basis | Motion interpretation | First-party source |
| --- | --- | --- | --- |
| OpenAI | Agents can select and use tools to carry out tasks. | Packets travel between a central coordinator and three tool nodes. | https://openai.com/index/introducing-chatgpt-agent/ |
| Claude | Thinking supports complex coding and tool-based tasks. | Successive code lines appear in an editor and a validation check completes. | https://platform.claude.com/docs/en/build-with-claude/thinking |
| Gemini | Multimodal models combine text with image and other media inputs. | Text, image and audio signals converge toward a shared output. | https://ai.google.dev/gemini-api/docs/get-started and https://ai.google.dev/gemini-api/docs/image-understanding |
| DeepSeek | R1 and its published weights emphasize reasoning capabilities. | A particle advances through a branching multi-step reasoning path. | https://github.com/deepseek-ai/DeepSeek-R1 |
| Hugging Face | The Hub hosts and shares models, datasets and applications. | Packets move through a hub linking dataset and model repositories. | https://huggingface.co/docs/hub/index |
| Ollama | Models can run locally through the application or terminal. | A local machine generates tokens inside its own screen. | https://docs.ollama.com/quickstart |

Vendor SVG sources and their upstream license are documented in README.md and LICENSE in this directory. The PNG layers in rendered/ are rasterizations of those SVG paths, used to create reliable GIF frames without external image services.
