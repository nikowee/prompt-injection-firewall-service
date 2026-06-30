# 1. Use an official, lightweight Python runtime environment as our foundation
FROM python:3.11-slim

# 2. Set the working directory inside the virtual container file system
WORKDIR /app

# 3. Install essential Linux compiler tools required to build llama.cpp from source
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# 4. Copy just our dependency files first to leverage Docker's smart build caching
RUN pip install --no-cache-dir fastapi uvicorn pydantic llama-cpp-python

# 5. Copy your local script and your downloaded 4.8GB GGUF model artifact into the container
COPY app.py /app/app.py
COPY llama-3-8b-instruct.Q4_K_M.gguf /app/llama-3-8b-instruct.Q4_K_M.gguf

# 6. Expose the networking port that FastAPI will communicate through
EXPOSE 8000

# 7. Execute the Uvicorn ASGI server to boot our API gateway on container startup
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]