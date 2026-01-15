![infrastructure-composer-PythonCdkStack yaml](https://github.com/user-attachments/assets/592d992b-665a-45bd-8227-420e59e7e9d9)

## Tagging Strategy

This project uses environment variables for dynamic tags (like `commitHash`) instead of the `cdk deploy --tags` CLI flag.

### Why not use `cdk deploy --tags`?

The CDK team has stated that [`--tags` should never have been a feature](https://github.com/aws/aws-cdk/issues/9259):

> "In hindsight, this is not a bug. cdk deploy --tags should never have been a feature and you shouldn't be using it. Tagging inside the CDK app is the proper way to do tagging."

**The problem:** CLI `--tags` passes tags via CloudFormation change sets as **stack-level tags**. These can **replace** rather than merge with existing stack-level tags, breaking tag propagation from custom Stack classes.

### How tags work in CDK

| Method | Where Applied | Behavior |
|--------|--------------|----------|
| `Tags.of(scope).add()` | CloudFormation template | Survives CLI changes, written directly to template |
| Stack constructor `tags={}` | CloudFormation Stack | Propagated by CloudFormation to resources |
| `cdk deploy --tags` | CloudFormation Stack | **May replace** existing stack-level tags |

### Our approach

```python
# In app.py - fallback chain: COMMIT_HASH -> GITHUB_SHA (shortened) -> "unknown"
commit_hash = os.environ.get("COMMIT_HASH") or os.environ.get("GITHUB_SHA", "")[:7] or "unknown"
cdk.Tags.of(app).add("commitHash", commit_hash)
```

| Environment | Source |
|-------------|--------|
| Local (Makefile) | `COMMIT_HASH` from `git rev-parse --short HEAD` |
| GitHub Actions | `GITHUB_SHA` (auto-shortened to 7 chars) |
| Other CI/CD | Set `COMMIT_HASH` explicitly |
| Fallback | `"unknown"` |

This ensures the `commitHash` tag is written directly into the CloudFormation template via `Tags.of()`, avoiding any stack-level tag replacement issues.

### References

- [GitHub Issue #9259 - CLI removes tags on self-mutating updates](https://github.com/aws/aws-cdk/issues/9259)
- [Tags and the AWS CDK - Official Guide](https://docs.aws.amazon.com/cdk/v2/guide/tagging.html)
- [CDK Tags API Reference](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.Tags.html)
