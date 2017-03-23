#!/bin/bash

function usage {
	echo "usage: $0: <kill-all-apps|delete-all-apps|delete-routes|setup-spaces>"
	exit 1
}

function pcfdev_login {
	cf login -a https://api.local.pcfdev.io \
		--skip-ssl-validation \
		-u admin \
		-p admin \
		-o pcfdev-org \
		-s pcfdev-test
}

[[ $# -eq 1 ]] || usage

case $1 in
	kill-all-apps)
		pcfdev_login

		cf target -o pcfdev-org -s pcfdev-test
		yes | cf stop sample-spring-cloud-svc

		cf target -o pcfdev-org -s pcfdev-stage
		yes | cf stop sample-spring-cloud-svc

		cf target -o pcfdev-org -s pcfdev-prod
		yes | cf stop sample-spring-cloud-svc
		yes | cf stop sample-spring-cloud-svc-venerable
		;;

	delete-all-apps)
		pcfdev_login

		cf target -o pcfdev-org -s pcfdev-test
		cf delete -f sample-spring-cloud-svc

		cf target -o pcfdev-org -s pcfdev-stage
		cf delete -f sample-spring-cloud-svc

		cf target -o pcfdev-org -s pcfdev-prod
		cf delete -f sample-spring-cloud-svc
		cf delete -f sample-spring-cloud-svc-venerable
		;;

	delete-routes)
		cf delete-route -f local.pcfdev.io -n sample-spring-cloud-svc-test
		cf delete-route -f local.pcfdev.io -n sample-spring-cloud-svc-stage
		cf delete-route -f local.pcfdev.io -n sample-spring-cloud-svc
		;;

	setup-spaces)
		pcfdev_login

		cf create-space pcfdev-test
		cf set-space-role user pcfdev-org pcfdev-test SpaceDeveloper

		cf create-space pcfdev-stage
		cf set-space-role user pcfdev-org pcfdev-stage SpaceDeveloper

		cf create-space pcfdev-prod
		cf set-space-role user pcfdev-org pcfdev-prod SpaceDeveloper
		;;

	*)
		usage
		;;
esac

