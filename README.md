# Sharp-AI-ly

Engineered a dockerized environment of an open-source [REAL ESRGAN model ↗](https://github.com/the-database/mpv-upscale-2x_animejanai) interfaced with a FlaskAPI on an AWS EC2 p2.xlarge instance, ensuring cost-effective scalability for GPU-intensive tasks through NVIDIA’s TensorRT SDK, leading to video enhancement in 2x time. Submitted to [TreeHacks 2024 ↗](https://devpost.com/software/sapheneia)

## Self-deploy steps

> **_NOTE:_**  To self-deploy, your machine needs to have an NVIDIA GPU running with the correct drivers. Make sure `nvidia-smi` works correctly.

1. `git clone https://github.com/nairvishnumail/Sharp-ai-ly.git`
2. Make sure you have docker and docker-compose: Get it [here](https://www.docker.com/get-started/)
3. Dockerize input and output directories `docker run -v "<project_path>/Sharpr-ai-ly/src/backend/ai/input:/input" -v "<project_path>/Sharpr-ai-ly/src/backend/ai/out:/out" -it `
4. `docker-compose run --rm vsgan_tensorrt`
5. `python app.py`

You now have the server running on at [localhost:8080](http://localhost:8080)

Send a POST request with video_url in the body to `http://localhost:8080/process-video` to get back a S3 object URL for the processed video
