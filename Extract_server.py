from fastapi import FastAPI, Request, Header
import uvicorn

app = FastAPI()


@app.post("/uploads")
async def blackhole_with_metadata(
        request: Request,
        x_key: str = Header(None),  # Matches meta->keyHex
        x_nonce: str = Header(None),  # Matches meta->nonceHex
        x_file: str = Header(None)  # Matches filename
):
    # Log the arrival of the "blob" and its metadata
    print(f"🚀 Receiving: {x_file}")
    print(f"🔑 Key: {x_key}")
    print(f"🎲 Nonce: {x_nonce}")

    bytes_received = 0
    # Stream the body to avoid loading the whole file into RAM
    async for chunk in request.stream():
        bytes_received += len(chunk)
        # Data is dropped here (the "Blackhole")

    print(f"✅ Swallowed {bytes_received} bytes from {x_file}\n")

    # Return 200 so the C code proceeds to overwrite the local file
    return {"message": "void consumed"}


if __name__ == "__main__":
    # Match the port you pass to your C program
    uvicorn.run(app, host="0.0.0.0", port=8000)