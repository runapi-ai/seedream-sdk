package ai.runapi.seedream.types;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import java.util.Objects;

/** Open model value for layer decomposition operations. */
public final class DecomposeLayersModel {
  public static final DecomposeLayersModel SEEDREAM_5_PRO_LAYER_DECOMPOSITION =
      new DecomposeLayersModel("seedream-5-pro-layer-decomposition");

  private final String value;

  /** Creates a model value from its public slug. */
  @JsonCreator
  public DecomposeLayersModel(String value) {
    this.value = SeedreamParamUtils.requireNonBlankTrim(value, "model");
  }

  /** Returns the public model slug. */
  @JsonValue
  public String value() {
    return value;
  }

  @Override
  public boolean equals(Object other) {
    return other instanceof DecomposeLayersModel && value.equals(((DecomposeLayersModel) other).value);
  }

  @Override
  public int hashCode() {
    return Objects.hash(value);
  }
}
