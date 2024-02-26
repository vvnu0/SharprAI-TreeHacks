# Sharp-AI-ly

Engineered a dockerized environment of an open-source [REAL ESRGAN model ↗](https://github.com/the-database/mpv-upscale-2x_animejanai) interfaced with a FlaskAPI on an AWS EC2 p2.xlarge instance, ensuring cost-effective scalability for GPU-intensive tasks through NVIDIA’s TensorRT SDK, leading to video enhancement in 2x time. Submitted to [TreeHacks 2024 ↗](https://devpost.com/software/sapheneia)

## Demo

https://github.com/nairvishnumail/Sharp-ai-ly/assets/27198773/c8b4ea97-988f-40ba-a6bb-5c9e5e5a19df

## AWS Deploy Steps

In order to deploy on AWS, you need to make sure that the AWS account has at least 4 vCPUs available. If you do not have at least 4 vCPUs, you can request more [here](https://support.console.aws.amazon.com/support/home?region=us-east-2#/case/create). Provide a reasonable explanation as to why you need it and within 24-48 hours you should have access to it. 

### EC2 launch steps: 

1. Launch an EC2 instance
2. Choose an appropriate AMI (important) - I chose Deep Learning OSS Nvidia Driver AMI GPU PyTorch 2.0.1 (Amazon Linux 2) 20240206
<img width="764" alt="image" src="https://github.com/nairvishnumail/Sharp-ai-ly/assets/27198773/69d364ac-1fed-4416-a1ba-29e178a8539d">

3. Choose p2.xlarge instance type. G instances do not work with the above AMI. But, feel free to try different types.
4. Create a security group to allow SSH traffic ("anywhere" is good for testing, but not recommended due to low security)
5. Choose 45 GB gp3 storage

> **_WARN:_**  AWS EC2 instances that need NVIDIA GPUs can be quite costly, so make sure you terminate the instance once you're done working with it.

### SSH & Setup NVIDIA drivers

1. ssh into the instance by clicking on "connect" and following the ssh steps
2. Follow steps [here](https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#ubuntu-lts) to setup NVIDIA SMI on your EC2 instance. This step is hard to get right since there are many different guides.

### Setting up server

Follow the self-deploy steps below on the instance to have the server up and working. 

## Self-deploy steps

> **_NOTE:_**  To self-deploy, your machine needs to have an NVIDIA GPU running with the correct drivers. Make sure `nvidia-smi` works correctly.

1. `git clone https://github.com/nairvishnumail/Sharp-ai-ly.git`
2. Make sure you have docker and docker-compose: Get it [here](https://www.docker.com/get-started/)
3. Dockerize input and output directories `docker run -v "<project_path>/Sharpr-ai-ly/src/backend/ai/input:/input" -v "<project_path>/Sharpr-ai-ly/src/backend/ai/out:/out" -it `
4. `docker-compose run --rm vsgan_tensorrt`
5. `python app.py`

You now have the server running on at [localhost:8080](http://localhost:8080)

Send a POST request with video_url in the body to `http://localhost:8080/process-video` to get back a S3 object URL for the processed video

For tunnelling a localhost environment, I used [ngrok](https://ngrok.com/download) that helped me hit the endpoint from different PCs
