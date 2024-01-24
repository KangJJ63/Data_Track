# run.py에서 my_module 함수 사용.
import my_module as mm
txt = mm.greet("Hong")
print(txt)

p = mm.Person("Lee",30)
print(p)

txt2 = mm.greet(p.name)
print(txt2)
