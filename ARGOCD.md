kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


#Install ArgoCD CLI
brew install argocd


#Use port-forwarding to access the ArgoCD API server:​

kubectl port-forward svc/argocd-server -n argocd 8080:443


#Retrieve the initial admin password:​
argocd admin initial-password -n argocd


argocd login localhost:8080




#Install Rollouts Controller
## Create the namespace and deploy the Rollouts controller:​

kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml


#Verify the installation:
kubectl api-resources | grep -i argo

#Install Rollouts Kubectl Plugin
brew install argoproj/tap/kubectl-argo-rollouts


Agrocd login 
admin
Admin@123