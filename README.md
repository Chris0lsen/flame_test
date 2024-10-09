# FlameTest

I've been using this project to test FLAME on minikube, to vet the k8s capabilities before trying anything in production. Here's my general workflow:

 - First, clone this repo and install [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download)
 - `minikube start` to fire up the cluster
 - `eval $(minikube docker-env)` to use minikube's docker repo
 - `cd` into flame_test, if you're not already there
 - `docker build -t flame_test:latest .` to build the image
 - `kubectl apply -f deployment.yaml` to start up the k8s resources
 - Get a shell into one of the pods in the cluster (I included a deployment of testing pods in `deployment.yaml`), e.g. `kubectl exec -n flame-namespace --stdin --tty iex-debug-deployment-7bfbfbc76f-5jkpm -- /bin/bash`
 - POST a request to one of the `flame-test` pods, e.g. `curl -X POST http://10.244.0.81:4000/call -d '{"data": 42}' -H "Content-Type: application/json"`
 - You'll get a response of `{message: ${data * 2}}` in your console! If you check the logs of whichever pod you sent the request to, you'll see a log line that tells you the node that actually processed your request! e.g. `Processed task on node :"flame_test@10.244.0.98"`    
