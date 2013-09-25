# !/usr/bin/python
# Filename: while.py
# 20120218

number=23
running=True

while running:
   guess=int(raw_input('Enter an integer:'))

   if guess == number:
      print 'Congratulations, you guessed it.'
      print '(but you do not win any prizes!)'
      Running = False
   elif guess < number:
      print 'No, it is higher than that.'
   else:
      print 'No, it is lower than that.'
else:
    print 'The while loop is over.'
print 'Done'

# you can only guess one time.
