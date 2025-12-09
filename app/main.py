from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse

app = FastAPI(
    title="Document Processor API",
    version="1.1.0"   # 👈 change this number each time to verify deployment
)

@app.post("/process")
async def process(file: UploadFile = File(...)):
    return JSONResponse({
        "status": "ok",
        "filename": file.filename
    })
