package ai.runapi.seedream.types;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Parameters for text to image operations. */
public final class TextToImageParams {
  private final String model;
  private final String prompt;
  private final String aspectRatio;
  private final String outputQuality;
  private final String outputResolution;
  private final Integer outputCount;
  private final Integer seed;
  private final Boolean enableSafetyChecker;
  private final String callbackUrl;

  private TextToImageParams(Builder builder) {
    this.model = builder.model;
    this.prompt = builder.prompt;
    this.aspectRatio = builder.aspectRatio;
    this.outputQuality = builder.outputQuality;
    this.outputResolution = builder.outputResolution;
    this.outputCount = builder.outputCount;
    this.seed = builder.seed;
    this.enableSafetyChecker = builder.enableSafetyChecker;
    this.callbackUrl = builder.callbackUrl;
  }

  /** Creates a new TextToImageParams builder. */
  public static Builder builder() {
    return new Builder();
  }

  /** Returns the RunAPI action key for this request. */
  public String action() {
    return "seedream/text-to-image";
  }

  /** Converts these parameters to the JSON request body shape. */
  public Map<String, Object> toMap() {
    Map<String, Object> raw = new LinkedHashMap<String, Object>();
    raw.put("model", SeedreamParamUtils.wireValue(model));
    raw.put("prompt", SeedreamParamUtils.wireValue(prompt));
    raw.put("aspect_ratio", SeedreamParamUtils.wireValue(aspectRatio));
    raw.put("output_quality", SeedreamParamUtils.wireValue(outputQuality));
    raw.put("output_resolution", SeedreamParamUtils.wireValue(outputResolution));
    raw.put("output_count", SeedreamParamUtils.wireValue(outputCount));
    raw.put("seed", SeedreamParamUtils.wireValue(seed));
    raw.put("enable_safety_checker", SeedreamParamUtils.wireValue(enableSafetyChecker));
    raw.put("callback_url", SeedreamParamUtils.wireValue(callbackUrl));
    return SeedreamParamUtils.compact(raw);
  }



  /** Builder for {@link TextToImageParams}. */
  public static final class Builder {
    private String model;
    private String prompt;
    private String aspectRatio;
    private String outputQuality;
    private String outputResolution;
    private Integer outputCount;
    private Integer seed;
    private Boolean enableSafetyChecker;
    private String callbackUrl;

    private Builder() {}

    /** Sets the model slug using a typed model value. */
    public Builder model(TextToImageModel value) {
      this.model = java.util.Objects.requireNonNull(value, "model").value();
      return this;
    }

    /** Sets the model slug using a string value. */
    public Builder model(String value) {
      this.model = SeedreamParamUtils.requireNonBlankTrim(value, "model");
      return this;
    }


    /** Sets the text prompt. */
    public Builder prompt(String value) {
      this.prompt = SeedreamParamUtils.requireNonBlank(value, "prompt");
      return this;
    }

    /** Sets the output aspect ratio. */
    public Builder aspectRatio(String value) {
      this.aspectRatio = SeedreamParamUtils.requireNonBlank(value, "aspectRatio");
      return this;
    }

    /** Sets the output quality. */
    public Builder outputQuality(String value) {
      this.outputQuality = SeedreamParamUtils.requireNonBlank(value, "outputQuality");
      return this;
    }

    /** Sets the output resolution. */
    public Builder outputResolution(String value) {
      this.outputResolution = SeedreamParamUtils.requireNonBlank(value, "outputResolution");
      return this;
    }

    /** Sets the number of generated outputs. */
    public Builder outputCount(int value) {
      this.outputCount = value;
      return this;
    }

    /** Sets the random seed. */
    public Builder seed(int value) {
      this.seed = value;
      return this;
    }

    /** Sets the content safety checker toggle. */
    public Builder enableSafetyChecker(boolean value) {
      this.enableSafetyChecker = value;
      return this;
    }

    /** Sets the webhook URL for task completion notifications. */
    public Builder callbackUrl(String value) {
      this.callbackUrl = SeedreamParamUtils.requireNonBlank(value, "callbackUrl");
      return this;
    }

    /** Builds immutable text to image parameters. */
    public TextToImageParams build() {
      return new TextToImageParams(this);
    }
  }
}
