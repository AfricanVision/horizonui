class DataWrapper {

    String value;

    DataWrapper({required this.value});

    factory DataWrapper.fromJson(Map<String, dynamic> json) {
        return DataWrapper(
            value: json['value'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['value'] = value;
        return data;
    }
}