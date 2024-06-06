def fiboncci(n):
  if n<= 1:
    return 1
  else:
    return fiboncci(n-1) + fiboncci(n-2)

n = int(input("No. of terms"))
for i in range(n):
  print(fiboncci(i))