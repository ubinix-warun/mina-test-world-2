sandbox-create() {
    export CHDIR="$PROJECT_DIR/terraform/mina-sandbox"
    scripts/terraform-init.sh
    scripts/terraform-validate.sh
    scripts/terraform-apply.sh
}

sandbox-destroy() {
    terraform -chdir=$PROJECT_DIR/terraform/mina-sandbox destroy
}