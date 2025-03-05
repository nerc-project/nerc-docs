from datetime import datetime
from decimal import Decimal

from jinja2 import Environment, FileSystemLoader

from nerc_rates import load_from_url

MiB_IN_GiB = GiB_in_TiB = 1024

SU_TYPE_LIST = [
    "CPU",
    "GPUA100",
    "GPUA100SXM4",
    "GPUV100",
    "GPUK80",
    "GPUH100",
    "BM FC430",
    "BM FC830",
    "BM GPUA100SXM4",
    "BM GPUH100",
]

SU_RESOURCETYPE_LIST = ["vCPUs", "vGPUs", "RAM"]

STORAGE_NAME = "Storage GB Rate"

TEMPLATE_FILE_LIST = [
    "docs/get-started/cost-billing/how-pricing-works.md",
    "docs/get-started/cost-billing/pricing-for-bare-metal-machines.md",
]


def get_current_month():
    return datetime.now().strftime("%Y-%m")


if __name__ == "__main__":
    env = Environment(loader=FileSystemLoader("."))
    rates_info = load_from_url()

    su_info_dict = {}
    for su_type in SU_TYPE_LIST:
        su_info_dict[su_type] = {}
        su_info_dict[su_type]["rate"] = Decimal(
            rates_info.get_value_at(f"{su_type} SU Rate", get_current_month())
        )
        for su_resourcetype in SU_RESOURCETYPE_LIST:
            su_resource_info = rates_info.get_value_at(
                f"{su_resourcetype} in {su_type} SU", get_current_month()
            )
            if su_resourcetype == "RAM":
                su_resource_info = Decimal(su_resource_info) / MiB_IN_GiB
            su_info_dict[su_type][su_resourcetype] = su_resource_info

    storage_rate = Decimal(rates_info.get_value_at(STORAGE_NAME, get_current_month()))
    storage_rate = (storage_rate * Decimal(GiB_in_TiB)).quantize(
        Decimal("0.001"), rounding="ROUND_UP"
    )  # Storage rates ar only shown in TiB in the docs
    su_info_dict[STORAGE_NAME] = {}
    su_info_dict[STORAGE_NAME]["rate"] = storage_rate

    for template_file in TEMPLATE_FILE_LIST:
        template = env.get_template(template_file)
        output = template.render(su_info_dict=su_info_dict)
        with open(template_file, "w") as f:
            f.write(output)
