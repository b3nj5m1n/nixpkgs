{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, kubeone
, testers
}:

buildGoModule rec {
  pname = "kubeone";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${version}";
    hash = "sha256-bFkJXnz4Nm1XfQMaBWSHfCxaTbGQQwKXRd1ktZKs7hY=";
  };

  vendorHash = "sha256-ZpTUhJyM+9e8b2EZzv4hsnV5G3HVPo6ga0pF3Ab53+A=";

  ldflags = [
    "-s"
    "-w"
    "-X k8c.io/kubeone/pkg/cmd.version=${version}"
    "-X k8c.io/kubeone/pkg/cmd.date=unknown"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd kubeone \
      --bash <($out/bin/kubeone completion bash) \
      --zsh <($out/bin/kubeone completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kubeone;
    command = "kubeone version";
  };

  meta = with lib; {
    description = "Automate cluster operations on all your cloud, on-prem, edge, and IoT environments";
    homepage = "https://kubeone.io/";
    changelog = "https://github.com/kubermatic/kubeone/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
  };
}
