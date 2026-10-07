#[test]
fn reads_a_fixture_relative_to_the_member() {
    let text = std::fs::read_to_string("tests/fixtures/x").unwrap();
    assert_eq!(text, workspace_member_tests::banana());
}
