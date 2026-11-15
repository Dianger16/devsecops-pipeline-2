IMG=devsecops-demo:local

.PHONY: docker-build docker-run docker-scan cluster deploy test-policies kyverno policies verify-rbac destroy

docker-build:
	docker build -t $(IMG) app

docker-run:
	docker run --rm -p 8000:8000 --read-only --cap-drop=ALL \
	  --security-opt no-new-privileges --tmpfs /tmp $(IMG)

docker-scan:
	trivy image --severity HIGH,CRITICAL $(IMG)
	docker images $(IMG)

cluster:
	kind create cluster --name secure --config kind-config.yaml
	kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml
	kubectl -n kube-system rollout status ds/calico-node --timeout=180s

deploy: docker-build
	kind load docker-image $(IMG) --name secure
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/serviceaccount.yaml -f k8s/rbac.yaml -f k8s/deployment.yaml \
	  -f k8s/service.yaml -f k8s/hpa.yaml -f k8s/pdb.yaml -f k8s/networkpolicy.yaml
	kubectl -n secure-app rollout status deploy/demo-app --timeout=120s

test-policies:
	./scripts/test-policies.sh

kyverno:
	helm repo add kyverno https://kyverno.github.io/kyverno/
	helm repo update
	helm install kyverno kyverno/kyverno -n kyverno --create-namespace

policies:
	kubectl apply -f kyverno/

verify-rbac:
	kubectl auth can-i list pods -n secure-app --as=viewer
	kubectl auth can-i delete pods -n secure-app --as=viewer
	kubectl auth can-i get secrets -n secure-app --as=system:serviceaccount:secure-app:demo-app

destroy:
	kind delete cluster --name secure
