.PHONY: synth diff deploy
deploy:
	COMMIT_HASH=$(shell git rev-parse --short HEAD) cdk deploy

synth:
	cdk synth

diff:
	cdk diff

updatecheck:
	uv pip list --outdated