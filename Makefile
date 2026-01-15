.PHONY: synth diff deploy
deploy: diff
	cdk deploy --tags commitHash=$(git rev-parse --short HEAD)

synth:
	cdk synth

diff:
	cdk diff

updatecheck:
	uv pip list --outdated