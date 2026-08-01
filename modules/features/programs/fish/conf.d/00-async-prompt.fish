# The async-prompt plugin only reads this value once when registering its
# refresh hooks, so any modifications to it must be done before it loads.
set -g async_prompt_on_variable fish_bind_mode PWD DEVENV_ROOT
