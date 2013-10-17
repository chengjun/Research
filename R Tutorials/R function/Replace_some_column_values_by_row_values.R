# Replace some column value by row values

s = data.frame(c(1, 2, 3), c(4, 5, 6))
s
s[s[,1]%in%c(2, 3),2] = s[s[,1]%in%c(2, 3),2] -5
s


# > s = data.frame(c(1, 2, 3), c(4, 5, 6))
# > s
# c.1..2..3. c.4..5..6.
# 1          1          4
# 2          2          5
# 3          3          6
# > s[s[,1]%in%c(2, 3),2] = s[s[,1]%in%c(2, 3),2] -5
# > s
# c.1..2..3. c.4..5..6.
# 1          1          4
# 2          2          0
# 3          3          1