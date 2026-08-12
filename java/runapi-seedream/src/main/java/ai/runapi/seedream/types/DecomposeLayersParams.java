package ai.runapi.seedream.types;

import java.util.LinkedHashMap;
import java.util.Map;

/** Parameters for layer decomposition operations. */
public final class DecomposeLayersParams {
  private final String model;
  private final String imageUrl;
  private final String prompt;
  private final String size;
  private final String outputFormat;
  private final String callbackUrl;

  private DecomposeLayersParams(Builder builder) {
    this.model = SeedreamParamUtils.requireNonBlank(builder.model, "model");
    this.imageUrl = SeedreamParamUtils.requireNonBlank(builder.imageUrl, "imageUrl");
    this.prompt = builder.prompt;
    this.size = builder.size;
    this.outputFormat = builder.outputFormat;
    this.callbackUrl = builder.callbackUrl;
  }

  /** Creates a new parameter builder. */
  public static Builder builder() {
    return new Builder();
  }

  /** Returns the RunAPI action key. */
  public String action() {
    return "seedream/decompose-layers";
  }

  /** Converts these parameters to the JSON request body. */
  public Map<String, Object> toMap() {
    Map<String, Object> raw = new LinkedHashMap<String, Object>();
    raw.put("model", SeedreamParamUtils.wireValue(model));
    raw.put("image_url", SeedreamParamUtils.wireValue(imageUrl));
    raw.put("prompt", SeedreamParamUtils.wireValue(prompt));
    raw.put("size", SeedreamParamUtils.wireValue(size));
    raw.put("output_format", SeedreamParamUtils.wireValue(outputFormat));
    raw.put("callback_url", SeedreamParamUtils.wireValue(callbackUrl));
    return SeedreamParamUtils.compact(raw);
  }

  /** Builder for {@link DecomposeLayersParams}. */
  public static final class Builder {
    private String model;
    private String imageUrl;
    private String prompt;
    private String size;
    private String outputFormat;
    private String callbackUrl;

    private Builder() {}

    public Builder model(DecomposeLayersModel value) {
      this.model = java.util.Objects.requireNonNull(value, "model").value();
      return this;
    }

    public Builder model(String value) {
      this.model = SeedreamParamUtils.requireNonBlankTrim(value, "model");
      return this;
    }

    public Builder imageUrl(String value) {
      this.imageUrl = SeedreamParamUtils.requireNonBlank(value, "imageUrl");
      return this;
    }

    public Builder prompt(String value) {
      this.prompt = SeedreamParamUtils.requireNonBlank(value, "prompt");
      return this;
    }

    public Builder size(String value) {
      this.size = SeedreamParamUtils.requireNonBlank(value, "size");
      return this;
    }

    public Builder outputFormat(String value) {
      this.outputFormat = SeedreamParamUtils.requireNonBlank(value, "outputFormat");
      return this;
    }

    public Builder callbackUrl(String value) {
      this.callbackUrl = SeedreamParamUtils.requireNonBlank(value, "callbackUrl");
      return this;
    }

    public DecomposeLayersParams build() {
      return new DecomposeLayersParams(this);
    }
  }
}
