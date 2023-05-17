vpc-create() {
    export CHDIR="$PROJECT_DIR/terraform/vpc"
    scripts/terraform-init.sh
    scripts/terraform-validate.sh
    scripts/terraform-apply.sh
}

vpc-destroy() {
    terraform -chdir=$PROJECT_DIR/terraform/vpc destroy
}