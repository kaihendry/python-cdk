from aws_cdk import (
    Stack,
    Tags,
)
from aws_cdk import (
    aws_iam as iam,
)
from constructs import Construct


class PythonCdkStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Create an IAM role that can be assumed by principals in the same account
        role = iam.Role(
            self,
            "IntraAccountRole",
            role_name="intra-account-role",  # Optional: you can remove this if you want CDK to generate a unique name
            assumed_by=iam.AccountPrincipal(
                self.account
            ),  # This allows any principal in your account to assume this role
            description="Role that can be assumed by principals in the same account",
        )

        # Add tags to track the source repository
        Tags.of(role).add("Source", "https://github.com/kaihendry/python-cdk")
        Tags.of(role).add("Repository", "python-cdk")
        Tags.of(role).add("ManagedBy", "AWS CDK")
