# Infrastructure

Repositorio de infraestructura local-first para Cloudflare DNS, Terraform, HCP Terraform y Ansible.

La prioridad actual es Terraform para manejar zonas y DNS en Cloudflare sin subir secretos al repo. El estado vive en HCP Terraform, pero los comandos se ejecutan desde la maquina local usando 1Password.

## Arquitectura

```text
.
├── modules/
│   └── cloudflare-zones/        # Modulo reutilizable para zonas y DNS
├── projects/
│   ├── cobosio/cobos-io/        # Org HCP cobosio, proyecto cobos.io
│   └── voltaflow/
│       ├── getdecant/           # Org HCP voltaflow
│       ├── voltaflow/
│       └── enkiflow/
├── scripts/
│   ├── bootstrap-macos.sh       # Prerrequisitos para macOS
│   └── tf-local.sh              # Wrapper local con 1Password
├── wiki/                        # Fuente para GitHub Wiki
├── ansible/                     # Automatizacion existente de servidores
├── AGENTS.md
├── CLAUDE.md
├── SKILLS.md
└── Makefile
```

## Decisiones

- Terraform oficial, no OpenTofu.
- HCP Terraform para state remoto y trazabilidad.
- Ejecucion local desde esta maquina. En HCP Terraform, configura los workspaces con execution mode local.
- Secretos via 1Password CLI con `op run`.
- Cloudflare por ahora solo zonas y DNS.
- Cloudflare Tunnel queda fuera.
- Un workspace por proyecto para reducir blast radius. No mezclar Cobos.io y Voltaflow en el mismo state.

## Prerrequisitos macOS

Instala las herramientas base:

```bash
./scripts/bootstrap-macos.sh
```

Luego prepara secretos locales:

```bash
cp .env.1password.example .env.1password
```

Edita `.env.1password` con referencias reales de 1Password, no valores planos.

Variables esperadas:

```dotenv
CLOUDFLARE_API_TOKEN=op://Infrastructure/Cloudflare/CLOUDFLARE_API_TOKEN
TF_TOKEN_app_terraform_io=op://Infrastructure/HCP Terraform/TF_TOKEN_app_terraform_io
```

## Uso

Revisar ambiente:

```bash
make doctor
```

Formatear Terraform:

```bash
make fmt
```

Validar un proyecto:

```bash
make validate PROJECT=cobosio/cobos-io
```

Plan:

```bash
make plan PROJECT=cobosio/cobos-io
```

Apply manual:

```bash
make apply PROJECT=cobosio/cobos-io
```

Validar todos:

```bash
make validate-all
```

## Proyectos Terraform

| Proyecto local | HCP organization | HCP project | Workspace |
| --- | --- | --- | --- |
| `cobosio/cobos-io` | `cobosio` | `cobos.io` | `cobos-io-cloudflare-dns` |
| `voltaflow/getdecant` | `voltaflow` | `getdecant` | `getdecant-cloudflare-dns` |
| `voltaflow/voltaflow` | `voltaflow` | `voltaflow` | `voltaflow-cloudflare-dns` |
| `voltaflow/enkiflow` | `voltaflow` | `enkiflow` | `enkiflow-cloudflare-dns` |

Cada proyecto tiene un `terraform.tfvars.example`. Copialo a `terraform.tfvars` localmente y llena el inventario real.

`terraform.tfvars` esta ignorado por git para no publicar inventarios privados en este repo.

## Adoptar zonas existentes

Para una zona que ya existe en Cloudflare:

1. Agrega la zona y sus records al `terraform.tfvars` local.
2. Ejecuta `make init PROJECT=<org>/<project>`.
3. Importa la zona al recurso del modulo.
4. Importa cada DNS record existente antes del primer `apply`.
5. Ejecuta `make plan PROJECT=<org>/<project>` y confirma que no hay recreaciones inesperadas.

Ejemplo conceptual:

```bash
terraform -chdir=projects/cobosio/cobos-io import \
  'module.cloudflare_zones.cloudflare_zone.managed["cobos.io"]' \
  '<cloudflare_zone_id>'

terraform -chdir=projects/cobosio/cobos-io import \
  'module.cloudflare_zones.cloudflare_dns_record.this["cobos.io/www-cname"]' \
  '<cloudflare_zone_id>/<dns_record_id>'
```

## Portfolio

El diagrama base para renderizar en portfolio vive en:

```text
docs/diagrams/cloudflare-platform.mmd
```

Tambien esta incluido en `wiki/Portfolio-Diagram.md` para GitHub Wiki.

## GitHub Wiki

La fuente del wiki vive en `wiki/`. Para publicarlo:

> Nota: GitHub no crea `ErnestoCobos/Infra.wiki.git` hasta guardar la primera pagina desde la UI. Si `git clone` devuelve `Repository not found`, abre <https://github.com/ErnestoCobos/Infra/wiki> con sesion iniciada, crea una pagina temporal `Home`, guardala, y luego ejecuta estos comandos para reemplazarla con la fuente versionada.

```bash
git clone git@github.com:ErnestoCobos/Infra.wiki.git /tmp/infra-wiki
rsync -av --delete wiki/ /tmp/infra-wiki/
git -C /tmp/infra-wiki add .
git -C /tmp/infra-wiki commit -m "docs: publish infrastructure wiki"
git -C /tmp/infra-wiki push
```

## Documentacion oficial usada

- [Terraform install](https://developer.hashicorp.com/terraform/install)
- [HCP Terraform CLI workflow](https://developer.hashicorp.com/terraform/cli/cloud)
- [Terraform cloud block](https://developer.hashicorp.com/terraform/language/block/terraform#cloud)
- [Cloudflare Terraform zones](https://developers.cloudflare.com/api/terraform/resources/zones/)
- [Cloudflare Terraform DNS records](https://developers.cloudflare.com/api/terraform/resources/dns/subresources/records/)
- [1Password CLI secret environments](https://developer.1password.com/docs/cli/secrets-environment-variables/)

## Ansible existente

`ansible/` y algunos workflows existentes vienen de la automatizacion previa de servidores. No son parte del nuevo flujo Terraform Cloudflare. No agregues automatizacion remota para Terraform sin una decision explicita.
