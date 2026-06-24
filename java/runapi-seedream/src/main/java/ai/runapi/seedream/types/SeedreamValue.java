package ai.runapi.seedream.types;

import ai.runapi.core.types.RunApiValue;

abstract class SeedreamValue extends RunApiValue {
  SeedreamValue(String value) {
    super(value);
  }
}
