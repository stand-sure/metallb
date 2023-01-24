#! /bin/bash
helm upgrade --install metallb bitnami/metallb --values value-overrides.yaml --namespace metallb-system --create-namespace