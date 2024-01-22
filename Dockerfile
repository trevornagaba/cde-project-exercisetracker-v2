FROM public.ecr.aws/lambda/nodejs:20
# Copy function code
COPY . .

RUN npm install

EXPOSE 3000
  
# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "index.handler" ]