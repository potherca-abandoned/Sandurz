
# ==============================================================================
# To help me not accidentally delete important stuff we just move it to the
# trash can. Using `sudo rm` or `\rm` will still kill you though. To have more
# fine-grained controll we use trash-cli (available in the vendor directory):
# https://github.com/andreafrancia/trash-cli/
# ------------------------------------------------------------------------------
alias rm='echo -e "This command has been disabled, use \033[1mtrash-rm\033[0m instead"; false'
# ==============================================================================
