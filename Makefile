.PHONY: synth diff deploy
deploy:
	cdk deploy --tags commitHash=$(shell git rev-parse --short HEAD)

synth:
	cdk synth

diff:
	cdk diff

updatecheck:
	uv pip list --outdated