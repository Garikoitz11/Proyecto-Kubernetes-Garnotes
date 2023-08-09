#!/bin/bash
kubectl apply -f reclamacion-vp-ldap-datos.yml
kubectl apply -f reclamacion-vp-ldap-conf.yml
kubectl apply -f reclamacion-vp-crate.yml
kubectl apply -f deployment-ldap.yml
kubectl apply -f deployment-crate.yml
kubectl apply -f deployment-web.yml
kubectl apply -f clusterip-ldap.yml
kubectl apply -f clusterip-crate.yml
kubectl apply -f loadbalancer.yml
kubectl apply -f horizontal-autoscaling-ldap.yml
kubectl apply -f horizontal-autoscaling-crate.yml
kubectl apply -f horizontal-autoscaling-web.yml
