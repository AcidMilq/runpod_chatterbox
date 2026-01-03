# 1. Start with a verified official RunPod PyTorch image
FROM runpod/pytorch:2.2.1-py3.10-cuda12.1.1-devel-ubuntu22.04

# 2. Install system dependencies
RUN apt-get update && apt-get install -y git wget curl ffmpeg

# 3. Install foundation libraries FIRST
# These ensure chatterbox doesn't crash during its own installation
RUN pip install --upgrade pip setuptools wheel
RUN pip install "numpy<1.26.0" pkuseg

WORKDIR /

# 4. Copy and install the rest of your requirements
COPY requirements.txt /requirements.txt
RUN pip install -r requirements.txt

# 5. Install Chatterbox WITHOUT dependencies to prevent conflicts
RUN pip install --no-deps chatterbox-tts

# 6. Copy your handler and pre-load the model
COPY rp_handler.py /
RUN python -c "from chatterbox.tts import ChatterboxTTS; model = ChatterboxTTS.from_pretrained(device='cuda')"

# 7. Start the container
CMD ["python3", "-u", "rp_handler.py"]

# model KadirErturk/image_info
