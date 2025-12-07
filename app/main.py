from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse

app = FastAPI()

@app.post("/process")
async def process(file: UploadFile = File(...)):
    return JSONResponse({
        "status": "ok",
        "filename": file.filename
    })
