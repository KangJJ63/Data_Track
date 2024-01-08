import os
def memo():
    os.makedirs("output",exist_ok=True)
    file_path = f"{os.getcwd()}/output/"
    title = input("파일명 : ")
    with open(f"{file_path}{title}.txt","wt",encoding = "UTF-8") as fw:
        print("="*5,"저장할 내용 입력","="*5)
        while True:
            txt = input(">>")
            if txt == r"!q":
                break
            fw.write(f"{txt}\n")
        print("프로그램 종료!")

if __name__ == "__main__":
    memo()
