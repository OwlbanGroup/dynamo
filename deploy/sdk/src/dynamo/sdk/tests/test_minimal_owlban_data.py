import unittest


from deploy.sdk.src.dynamo.sdk.lib.owlban_data import OwlbanData


class TestOwlbanDataMinimal(unittest.TestCase):
    def setUp(self):
        # Initialize with default base_path
        self.owlban_data = OwlbanData()

    def test_get_revenue_data_returns_dict(self):
        revenue = self.owlban_data.get_revenue_data()
        self.assertIsInstance(
            revenue, dict, "Revenue data should be a dictionary"
        )

    def test_get_banking_data_returns_dict(self):
        banking = self.owlban_data.get_banking_data()
        self.assertIsInstance(
            banking, dict, "Banking data should be a dictionary"
        )


if __name__ == "__main__":
    unittest.main()
