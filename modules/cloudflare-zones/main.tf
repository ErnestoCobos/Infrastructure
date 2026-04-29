locals {
  managed_zones = {
    for zone_name, zone in var.zones : zone_name => zone
    if try(zone.zone_id, null) == null
  }

  external_zones = {
    for zone_name, zone in var.zones : zone_name => zone
    if try(zone.zone_id, null) != null
  }

  dns_records = merge(
    {},
    [
      for zone_name, zone in var.zones : {
        for record_key, record in try(zone.records, {}) :
        "${zone_name}/${record_key}" => merge(record, {
          key       = record_key
          zone_name = zone_name
        })
      }
    ]...
  )

  zone_ids = merge(
    {
      for zone_name, zone in cloudflare_zone.managed :
      zone_name => zone.id
    },
    {
      for zone_name, zone in data.cloudflare_zone.external :
      zone_name => zone.id
    }
  )
}

resource "cloudflare_zone" "managed" {
  for_each = local.managed_zones

  account = {
    id = var.account_id
  }

  name = each.key
  type = each.value.type
}

data "cloudflare_zone" "external" {
  for_each = local.external_zones

  zone_id = each.value.zone_id
}

resource "cloudflare_dns_record" "this" {
  for_each = local.dns_records

  zone_id         = local.zone_ids[each.value.zone_name]
  name            = each.value.name
  type            = upper(each.value.type)
  content         = try(each.value.content, null)
  ttl             = try(each.value.ttl, 1)
  proxied         = try(each.value.proxied, null)
  priority        = try(each.value.priority, null)
  comment         = try(each.value.comment, null)
  tags            = try(each.value.tags, [])
  data            = try(each.value.data, null)
  settings        = try(each.value.settings, null)
  private_routing = try(each.value.private_routing, null)
}
