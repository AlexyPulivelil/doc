from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_process_endpoint():
    response = client.post(
        "/process",
        files={"file": ("sample.txt", b"hello world")}
    )

    assert response.status_code == 200
    assert response.json()["status"] == "ok"
    assert response.json()["filename"] == "sample.txt"