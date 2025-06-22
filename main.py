
import typer
import requests

app = typer.Typer()

@app.command()
def water(q: int):
    print("h")
    global isDrink
    isDrink = True
    if q == 0:
        isDrink = False
    res = requests.post("http://127.0.0.1:8000/v1/waterlog", json={"isDrink": True, "quantity": q})
    print(res.status_code)
    

if __name__ == "__main__":
    app()