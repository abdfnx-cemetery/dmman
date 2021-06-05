# in text field, sometimes the user want to send emojies

showEmojiPicker = False

# emoji picker
def showEmojiContainer():
    pass

def hideEmojiContainer():
    pass

# keyboard
def hideKeyboard():
    pass

def showKeyboard():
    pass

if (not showEmojiPicker):
    hideKeyboard()
    showEmojiContainer()

else:
    showKeyboard()
    hideEmojiContainer()
