#!/bin/sh

CLUSTER_NAME="cluster-${USER}"
CERT_ARGOCD="${HOME}/.argocd_certificate"
ARGO_CONFS_FOLDER="confs"

# $1: command name
check_command() {
	if ! type "${1}" 1>/dev/null 2>/dev/null ; then
		echo "error: command ${1} is not installed"
		exit 1
	fi
}

check_commands() {
	check_command "k3d"
	check_command "argocd"
	check_command "kubectl"
	check_command "openssl"
}

k3d_init() {
	k3d cluster create "${CLUSTER_NAME}" --api-port 6445 --port "8080:30000@server:0"
}

kubectl_namespace() {
	kubectl create namespace argocd
	kubectl create namespace dev
}

argocd_configure() {
	kubectl apply -n argocd -f "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"

	kubectl create -n argocd secret tls argocd-server-tls \
	  --cert "${CERT_ARGOCD}/server.crt" \
	  --key "${CERT_ARGOCD}/server.key"


   kubectl apply -f ${ARGO_CONFS_FOLDER}/application.yml -n argocd
   kubectl apply -f ${ARGO_CONFS_FOLDER}/appProject.yml -n argocd
}

generate_certificate() {
	mkdir -p "${CERT_ARGOCD}"

	SERVER_KEY="${CERT_ARGOCD}/server.key"
	SERVER_CSR="${CERT_ARGOCD}/server.csr"
	SERVER_CRT="${CERT_ARGOCD}/server.crt"
	EXTFILE="${CERT_ARGOCD}/cert_ext.cnf"

	cat > "${EXTFILE}" <<- eof
	[req]
	default_bit = 4096
	distinguished_name = req_distinguished_name
	prompt = no

	[req_distinguished_name]
	countryName             = CH
	stateOrProvinceName     = Vaud
	localityName            = Lausanne
	organizationName        = 42Lausanne
	commonName              = $(uname -n)
	eof

	echo "Generating private key"
	openssl genrsa -out ${SERVER_KEY} 4096

	echo "Generating Certificate Signing Request"
	openssl req -new -key ${SERVER_KEY} -out ${SERVER_CSR} -config ${EXTFILE}

	echo "Generating self signed certificate"
	openssl x509 -req -days 3650 -in ${SERVER_CSR} -signkey ${SERVER_KEY} -out ${SERVER_CRT}
}

port_forwarding_argocd() {
    while ! kubectl get pods -n argocd | grep argocd-server | grep -q "Running"; do
        echo "Waiting for the argocd-server service to be running and available to accept requests..."
        sleep 5
    done

  	kubectl port-forward svc/argocd-server -n argocd 10999:443 > /dev/null 2>&1 &
}

waiting_for_wil42_app() {
    while ! kubectl get pods -n dev | grep wil42-app | grep -q "Running" || [ -z "$(kubectl get pods -n dev | grep wil42-app)" ] ; do
        echo "Waiting for the wil42-app-service to be running and available to accept requests..."
        sleep 5
    done
}

print_infos(){
  	echo "ArgoCD: http://localhost:10999"
  	echo "ArgoCD Username: admin"
  	echo "ArgoCD Password: $(kubectl --namespace argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
  	echo "will42-app: curl http://localhost:8080"
}

main() {
	check_commands

	generate_certificate

	k3d_init
	kubectl_namespace
	argocd_configure
	port_forwarding_argocd
	waiting_for_wil42_app
	print_infos
}

if [ "$(basename $(pwd))" != "p3" ]; then
	echo "error: you have to run the script in p3 folder"
	exit 1
fi

if [ ! -d "${ARGO_CONFS_FOLDER}" ]; then
	echo "error: folder \"${ARGO_CONFS_FOLDER}\""
	exit 1
fi

main
