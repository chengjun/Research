import logscan
# $ cat readfile.py
#!/usr/local/bin/python

f = open("example.log", "r")
text = f.read()
print text
f.close()
# $
# LogProcessor(text)
print logscan.LogProcessor(text)
print logscan.LogProcessor.parse(text)
