mock_provider "scaleway" {}
mock_provider "time" {}

variables {
  name = "test-db"
}

run "defaults_are_valid" {
  command = plan
}

run "negative_keys_ttl_is_rejected" {
  command = plan

  variables {
    keys_ttl = -5
  }

  expect_failures = [var.keys_ttl]
}

run "fractional_keys_ttl_is_rejected" {
  command = plan

  variables {
    keys_ttl = 1.5
  }

  expect_failures = [var.keys_ttl]
}

run "null_keys_ttl_falls_back_to_default" {
  command = plan

  variables {
    keys_ttl = null
  }
}

run "max_cpu_above_api_range_is_rejected" {
  command = plan

  variables {
    max_cpu = 20
  }

  expect_failures = [var.max_cpu]
}

run "min_cpu_below_api_range_is_rejected" {
  command = plan

  variables {
    min_cpu = -1
  }

  expect_failures = [var.min_cpu]
}

run "min_cpu_greater_than_max_cpu_is_rejected" {
  command = plan

  variables {
    min_cpu = 10
    max_cpu = 2
  }

  expect_failures = [var.max_cpu]
}

run "min_cpu_equal_to_max_cpu_is_valid" {
  command = plan

  variables {
    min_cpu = 5
    max_cpu = 5
  }
}
