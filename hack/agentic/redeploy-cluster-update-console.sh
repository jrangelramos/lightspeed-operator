#!/usr/bin/env bash
# Rebuilds and redeploys the cluster-update console plugin.
# This plugin is deployed standalone (not managed by the operator).
#
# Usage:
#   KUBECONFIG=/path/to/kubeconfig bash hack/agentic/redeploy-cluster-update-console.sh
#   KUBECONFIG=/path/to/kubeconfig bash hack/agentic/redeploy-cluster-update-console.sh --skip-build
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
parse_args "$@"

[[ -d "${CLUSTER_UPDATE_DIR}" ]] || fail "Cluster-update console directory not found: ${CLUSTER_UPDATE_DIR}"

check_cluster
ensure_buildconfigs

build_on_cluster "${BC_CLUSTER_UPDATE}" "${CLUSTER_UPDATE_DIR}" "cluster-update console plugin"

deploy_cluster_update_plugin

step "Restarting cluster-update console deployment"
rollout "${DEPLOY_CLUSTER_UPDATE}" "${NS_OPERATOR}" "Cluster-update console plugin"

echo -e "\n${GREEN}Cluster-update console plugin redeployed.${NC}"
