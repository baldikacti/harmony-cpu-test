
```bash
# Setup resources
kubectl apply -f nf_namespace.yaml
kubectl apply -f nf_pv.yaml
kubectl apply -f nf_sa.yaml
# Run job
kubectl apply -f nf_job.yaml

# Clean pods after done or failed job
kubectl delete jobs --all -n nextflow-stresstest

# Watch progress of a job
kubectl logs pod/nextflow-cputest-pipeline-sd5l2 -n nextflow-stresstest -f
```