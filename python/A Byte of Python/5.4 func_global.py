# func_global.py

def func():
    global x
    # set x as a global value
    print 'x is', x
    x=2
    print 'Changed global x to', x
x=50
func()
print 'value of x is', x

