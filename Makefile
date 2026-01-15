.PHONY: synth diff deploy
deploy: diff
	cdk deploy

synth:
	cdk synth

diff:
	cdk diff

updatecheck:
	uv pip list --outdated