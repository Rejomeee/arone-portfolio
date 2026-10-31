String? readLocalDraft() => null;
bool writeLocalDraft(String value) => false;
void clearLocalDraft() {}
void exportContentJson(String value) =>
    throw UnsupportedError('Export is available in a web browser.');
